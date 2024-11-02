
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

// Recursive function in which it goes for all the files in the directory and subdirectories to find a specific file
void find(char *directory_path, char *target_file)
{
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	25213823          	sd	s2,592(sp)
  10:	25313423          	sd	s3,584(sp)
  14:	1c80                	addi	s0,sp,624
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
  int directory_fd;
  struct dirent directory_entry;
  struct stat stat_buffer;

  // Try to open the directory, if it fails, print an error and return
  if((directory_fd = open(directory_path, O_RDONLY)) < 0){
  1a:	4581                	li	a1,0
  1c:	44c000ef          	jal	468 <open>
  20:	04054763          	bltz	a0,6e <find+0x6e>
  24:	24913c23          	sd	s1,600(sp)
  28:	84aa                	mv	s1,a0
    fprintf(2, "search_file: cannot open %s\n", directory_path);
    return;
  }

  // Get the status of the directory to verify if it's valid 
  if(fstat(directory_fd, &stat_buffer) < 0){
  2a:	d9840593          	addi	a1,s0,-616
  2e:	452000ef          	jal	480 <fstat>
  32:	04054763          	bltz	a0,80 <find+0x80>
    close(directory_fd);
    return;
  }

  // Ensure the provided path is a directory
  if(stat_buffer.type != T_DIR){
  36:	da041703          	lh	a4,-608(s0)
  3a:	4785                	li	a5,1
  3c:	06f70063          	beq	a4,a5,9c <find+0x9c>
    fprintf(2, "search_file: first argument must be a directory\n");
  40:	00001597          	auipc	a1,0x1
  44:	9f858593          	addi	a1,a1,-1544 # a38 <malloc+0x144>
  48:	4509                	li	a0,2
  4a:	7cc000ef          	jal	816 <fprintf>
    close(directory_fd);
  4e:	8526                	mv	a0,s1
  50:	400000ef          	jal	450 <close>
    return;
  54:	25813483          	ld	s1,600(sp)
    else if(stat_buffer.type == T_FILE && strcmp(path_pointer, target_file) == 0){
      printf("%s\n", path_buffer);
    }
  }
  close(directory_fd);
}
  58:	26813083          	ld	ra,616(sp)
  5c:	26013403          	ld	s0,608(sp)
  60:	25013903          	ld	s2,592(sp)
  64:	24813983          	ld	s3,584(sp)
  68:	27010113          	addi	sp,sp,624
  6c:	8082                	ret
    fprintf(2, "search_file: cannot open %s\n", directory_path);
  6e:	864a                	mv	a2,s2
  70:	00001597          	auipc	a1,0x1
  74:	98058593          	addi	a1,a1,-1664 # 9f0 <malloc+0xfc>
  78:	4509                	li	a0,2
  7a:	79c000ef          	jal	816 <fprintf>
    return;
  7e:	bfe9                	j	58 <find+0x58>
    fprintf(2, "search_file: cannot stat %s\n", directory_path);
  80:	864a                	mv	a2,s2
  82:	00001597          	auipc	a1,0x1
  86:	99658593          	addi	a1,a1,-1642 # a18 <malloc+0x124>
  8a:	4509                	li	a0,2
  8c:	78a000ef          	jal	816 <fprintf>
    close(directory_fd);
  90:	8526                	mv	a0,s1
  92:	3be000ef          	jal	450 <close>
    return;
  96:	25813483          	ld	s1,600(sp)
  9a:	bf7d                	j	58 <find+0x58>
  9c:	25413023          	sd	s4,576(sp)
  a0:	23513c23          	sd	s5,568(sp)
  a4:	23613823          	sd	s6,560(sp)
  strcpy(path_buffer, directory_path);
  a8:	85ca                	mv	a1,s2
  aa:	dc040513          	addi	a0,s0,-576
  ae:	122000ef          	jal	1d0 <strcpy>
  path_pointer = path_buffer + strlen(path_buffer);
  b2:	dc040513          	addi	a0,s0,-576
  b6:	162000ef          	jal	218 <strlen>
  ba:	1502                	slli	a0,a0,0x20
  bc:	9101                	srli	a0,a0,0x20
  be:	dc040793          	addi	a5,s0,-576
  c2:	00a78933          	add	s2,a5,a0
  *path_pointer++ = '/';
  c6:	00190a13          	addi	s4,s2,1
  ca:	02f00793          	li	a5,47
  ce:	00f90023          	sb	a5,0(s2)
    if(stat_buffer.type == T_DIR && strcmp(path_pointer, ".") != 0 && strcmp(path_pointer, "..") != 0){
  d2:	4a85                	li	s5,1
    else if(stat_buffer.type == T_FILE && strcmp(path_pointer, target_file) == 0){
  d4:	4b09                	li	s6,2
  while(read(directory_fd, &directory_entry, sizeof(directory_entry)) == sizeof(directory_entry)){
  d6:	4641                	li	a2,16
  d8:	db040593          	addi	a1,s0,-592
  dc:	8526                	mv	a0,s1
  de:	362000ef          	jal	440 <read>
  e2:	47c1                	li	a5,16
  e4:	08f51863          	bne	a0,a5,174 <find+0x174>
    if(directory_entry.inum == 0) continue; // Skip invalid entries
  e8:	db045783          	lhu	a5,-592(s0)
  ec:	d7ed                	beqz	a5,d6 <find+0xd6>
    memmove(path_pointer, directory_entry.name, DIRSIZ);
  ee:	4639                	li	a2,14
  f0:	db240593          	addi	a1,s0,-590
  f4:	8552                	mv	a0,s4
  f6:	284000ef          	jal	37a <memmove>
    path_pointer[DIRSIZ] = 0;
  fa:	000907a3          	sb	zero,15(s2)
    if(stat(path_buffer, &stat_buffer) < 0){
  fe:	d9840593          	addi	a1,s0,-616
 102:	dc040513          	addi	a0,s0,-576
 106:	1f2000ef          	jal	2f8 <stat>
 10a:	02054663          	bltz	a0,136 <find+0x136>
    if(stat_buffer.type == T_DIR && strcmp(path_pointer, ".") != 0 && strcmp(path_pointer, "..") != 0){
 10e:	da041783          	lh	a5,-608(s0)
 112:	03578b63          	beq	a5,s5,148 <find+0x148>
    else if(stat_buffer.type == T_FILE && strcmp(path_pointer, target_file) == 0){
 116:	fd6790e3          	bne	a5,s6,d6 <find+0xd6>
 11a:	85ce                	mv	a1,s3
 11c:	8552                	mv	a0,s4
 11e:	0ce000ef          	jal	1ec <strcmp>
 122:	f955                	bnez	a0,d6 <find+0xd6>
      printf("%s\n", path_buffer);
 124:	dc040593          	addi	a1,s0,-576
 128:	00001517          	auipc	a0,0x1
 12c:	95850513          	addi	a0,a0,-1704 # a80 <malloc+0x18c>
 130:	710000ef          	jal	840 <printf>
 134:	b74d                	j	d6 <find+0xd6>
      printf("search_file: cannot stat %s\n", path_buffer);
 136:	dc040593          	addi	a1,s0,-576
 13a:	00001517          	auipc	a0,0x1
 13e:	8de50513          	addi	a0,a0,-1826 # a18 <malloc+0x124>
 142:	6fe000ef          	jal	840 <printf>
      continue;
 146:	bf41                	j	d6 <find+0xd6>
    if(stat_buffer.type == T_DIR && strcmp(path_pointer, ".") != 0 && strcmp(path_pointer, "..") != 0){
 148:	00001597          	auipc	a1,0x1
 14c:	92858593          	addi	a1,a1,-1752 # a70 <malloc+0x17c>
 150:	8552                	mv	a0,s4
 152:	09a000ef          	jal	1ec <strcmp>
 156:	d141                	beqz	a0,d6 <find+0xd6>
 158:	00001597          	auipc	a1,0x1
 15c:	92058593          	addi	a1,a1,-1760 # a78 <malloc+0x184>
 160:	8552                	mv	a0,s4
 162:	08a000ef          	jal	1ec <strcmp>
 166:	d925                	beqz	a0,d6 <find+0xd6>
      find(path_buffer, target_file);
 168:	85ce                	mv	a1,s3
 16a:	dc040513          	addi	a0,s0,-576
 16e:	e93ff0ef          	jal	0 <find>
 172:	b795                	j	d6 <find+0xd6>
  close(directory_fd);
 174:	8526                	mv	a0,s1
 176:	2da000ef          	jal	450 <close>
 17a:	25813483          	ld	s1,600(sp)
 17e:	24013a03          	ld	s4,576(sp)
 182:	23813a83          	ld	s5,568(sp)
 186:	23013b03          	ld	s6,560(sp)
 18a:	b5f9                	j	58 <find+0x58>

000000000000018c <main>:

int main(int argc, char *argv[])
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e406                	sd	ra,8(sp)
 190:	e022                	sd	s0,0(sp)
 192:	0800                	addi	s0,sp,16
  if(argc != 3){
 194:	470d                	li	a4,3
 196:	00e50c63          	beq	a0,a4,1ae <main+0x22>
    fprintf(2, "Usage: search_file <directory> <file>\n");
 19a:	00001597          	auipc	a1,0x1
 19e:	8ee58593          	addi	a1,a1,-1810 # a88 <malloc+0x194>
 1a2:	4509                	li	a0,2
 1a4:	672000ef          	jal	816 <fprintf>
    exit(1);
 1a8:	4505                	li	a0,1
 1aa:	27e000ef          	jal	428 <exit>
 1ae:	87ae                	mv	a5,a1
  }

  find(argv[1], argv[2]);
 1b0:	698c                	ld	a1,16(a1)
 1b2:	6788                	ld	a0,8(a5)
 1b4:	e4dff0ef          	jal	0 <find>
  
  exit(0);
 1b8:	4501                	li	a0,0
 1ba:	26e000ef          	jal	428 <exit>

00000000000001be <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1c6:	fc7ff0ef          	jal	18c <main>
  exit(0);
 1ca:	4501                	li	a0,0
 1cc:	25c000ef          	jal	428 <exit>

00000000000001d0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d6:	87aa                	mv	a5,a0
 1d8:	0585                	addi	a1,a1,1
 1da:	0785                	addi	a5,a5,1
 1dc:	fff5c703          	lbu	a4,-1(a1)
 1e0:	fee78fa3          	sb	a4,-1(a5)
 1e4:	fb75                	bnez	a4,1d8 <strcpy+0x8>
    ;
  return os;
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cb91                	beqz	a5,20a <strcmp+0x1e>
 1f8:	0005c703          	lbu	a4,0(a1)
 1fc:	00f71763          	bne	a4,a5,20a <strcmp+0x1e>
    p++, q++;
 200:	0505                	addi	a0,a0,1
 202:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 204:	00054783          	lbu	a5,0(a0)
 208:	fbe5                	bnez	a5,1f8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 20a:	0005c503          	lbu	a0,0(a1)
}
 20e:	40a7853b          	subw	a0,a5,a0
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strlen>:

uint
strlen(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 21e:	00054783          	lbu	a5,0(a0)
 222:	cf91                	beqz	a5,23e <strlen+0x26>
 224:	0505                	addi	a0,a0,1
 226:	87aa                	mv	a5,a0
 228:	86be                	mv	a3,a5
 22a:	0785                	addi	a5,a5,1
 22c:	fff7c703          	lbu	a4,-1(a5)
 230:	ff65                	bnez	a4,228 <strlen+0x10>
 232:	40a6853b          	subw	a0,a3,a0
 236:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
  for(n = 0; s[n]; n++)
 23e:	4501                	li	a0,0
 240:	bfe5                	j	238 <strlen+0x20>

0000000000000242 <memset>:

void*
memset(void *dst, int c, uint n)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 248:	ca19                	beqz	a2,25e <memset+0x1c>
 24a:	87aa                	mv	a5,a0
 24c:	1602                	slli	a2,a2,0x20
 24e:	9201                	srli	a2,a2,0x20
 250:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 254:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 258:	0785                	addi	a5,a5,1
 25a:	fee79de3          	bne	a5,a4,254 <memset+0x12>
  }
  return dst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <strchr>:

char*
strchr(const char *s, char c)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  for(; *s; s++)
 26a:	00054783          	lbu	a5,0(a0)
 26e:	cb99                	beqz	a5,284 <strchr+0x20>
    if(*s == c)
 270:	00f58763          	beq	a1,a5,27e <strchr+0x1a>
  for(; *s; s++)
 274:	0505                	addi	a0,a0,1
 276:	00054783          	lbu	a5,0(a0)
 27a:	fbfd                	bnez	a5,270 <strchr+0xc>
      return (char*)s;
  return 0;
 27c:	4501                	li	a0,0
}
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
  return 0;
 284:	4501                	li	a0,0
 286:	bfe5                	j	27e <strchr+0x1a>

0000000000000288 <gets>:

char*
gets(char *buf, int max)
{
 288:	711d                	addi	sp,sp,-96
 28a:	ec86                	sd	ra,88(sp)
 28c:	e8a2                	sd	s0,80(sp)
 28e:	e4a6                	sd	s1,72(sp)
 290:	e0ca                	sd	s2,64(sp)
 292:	fc4e                	sd	s3,56(sp)
 294:	f852                	sd	s4,48(sp)
 296:	f456                	sd	s5,40(sp)
 298:	f05a                	sd	s6,32(sp)
 29a:	ec5e                	sd	s7,24(sp)
 29c:	1080                	addi	s0,sp,96
 29e:	8baa                	mv	s7,a0
 2a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a2:	892a                	mv	s2,a0
 2a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a6:	4aa9                	li	s5,10
 2a8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2aa:	89a6                	mv	s3,s1
 2ac:	2485                	addiw	s1,s1,1
 2ae:	0344d663          	bge	s1,s4,2da <gets+0x52>
    cc = read(0, &c, 1);
 2b2:	4605                	li	a2,1
 2b4:	faf40593          	addi	a1,s0,-81
 2b8:	4501                	li	a0,0
 2ba:	186000ef          	jal	440 <read>
    if(cc < 1)
 2be:	00a05e63          	blez	a0,2da <gets+0x52>
    buf[i++] = c;
 2c2:	faf44783          	lbu	a5,-81(s0)
 2c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ca:	01578763          	beq	a5,s5,2d8 <gets+0x50>
 2ce:	0905                	addi	s2,s2,1
 2d0:	fd679de3          	bne	a5,s6,2aa <gets+0x22>
    buf[i++] = c;
 2d4:	89a6                	mv	s3,s1
 2d6:	a011                	j	2da <gets+0x52>
 2d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2da:	99de                	add	s3,s3,s7
 2dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 2e0:	855e                	mv	a0,s7
 2e2:	60e6                	ld	ra,88(sp)
 2e4:	6446                	ld	s0,80(sp)
 2e6:	64a6                	ld	s1,72(sp)
 2e8:	6906                	ld	s2,64(sp)
 2ea:	79e2                	ld	s3,56(sp)
 2ec:	7a42                	ld	s4,48(sp)
 2ee:	7aa2                	ld	s5,40(sp)
 2f0:	7b02                	ld	s6,32(sp)
 2f2:	6be2                	ld	s7,24(sp)
 2f4:	6125                	addi	sp,sp,96
 2f6:	8082                	ret

00000000000002f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f8:	1101                	addi	sp,sp,-32
 2fa:	ec06                	sd	ra,24(sp)
 2fc:	e822                	sd	s0,16(sp)
 2fe:	e04a                	sd	s2,0(sp)
 300:	1000                	addi	s0,sp,32
 302:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 304:	4581                	li	a1,0
 306:	162000ef          	jal	468 <open>
  if(fd < 0)
 30a:	02054263          	bltz	a0,32e <stat+0x36>
 30e:	e426                	sd	s1,8(sp)
 310:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 312:	85ca                	mv	a1,s2
 314:	16c000ef          	jal	480 <fstat>
 318:	892a                	mv	s2,a0
  close(fd);
 31a:	8526                	mv	a0,s1
 31c:	134000ef          	jal	450 <close>
  return r;
 320:	64a2                	ld	s1,8(sp)
}
 322:	854a                	mv	a0,s2
 324:	60e2                	ld	ra,24(sp)
 326:	6442                	ld	s0,16(sp)
 328:	6902                	ld	s2,0(sp)
 32a:	6105                	addi	sp,sp,32
 32c:	8082                	ret
    return -1;
 32e:	597d                	li	s2,-1
 330:	bfcd                	j	322 <stat+0x2a>

0000000000000332 <atoi>:

int
atoi(const char *s)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 338:	00054683          	lbu	a3,0(a0)
 33c:	fd06879b          	addiw	a5,a3,-48
 340:	0ff7f793          	zext.b	a5,a5
 344:	4625                	li	a2,9
 346:	02f66863          	bltu	a2,a5,376 <atoi+0x44>
 34a:	872a                	mv	a4,a0
  n = 0;
 34c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 34e:	0705                	addi	a4,a4,1
 350:	0025179b          	slliw	a5,a0,0x2
 354:	9fa9                	addw	a5,a5,a0
 356:	0017979b          	slliw	a5,a5,0x1
 35a:	9fb5                	addw	a5,a5,a3
 35c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 360:	00074683          	lbu	a3,0(a4)
 364:	fd06879b          	addiw	a5,a3,-48
 368:	0ff7f793          	zext.b	a5,a5
 36c:	fef671e3          	bgeu	a2,a5,34e <atoi+0x1c>
  return n;
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
  n = 0;
 376:	4501                	li	a0,0
 378:	bfe5                	j	370 <atoi+0x3e>

000000000000037a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e422                	sd	s0,8(sp)
 37e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 380:	02b57463          	bgeu	a0,a1,3a8 <memmove+0x2e>
    while(n-- > 0)
 384:	00c05f63          	blez	a2,3a2 <memmove+0x28>
 388:	1602                	slli	a2,a2,0x20
 38a:	9201                	srli	a2,a2,0x20
 38c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 390:	872a                	mv	a4,a0
      *dst++ = *src++;
 392:	0585                	addi	a1,a1,1
 394:	0705                	addi	a4,a4,1
 396:	fff5c683          	lbu	a3,-1(a1)
 39a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 39e:	fef71ae3          	bne	a4,a5,392 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
    dst += n;
 3a8:	00c50733          	add	a4,a0,a2
    src += n;
 3ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ae:	fec05ae3          	blez	a2,3a2 <memmove+0x28>
 3b2:	fff6079b          	addiw	a5,a2,-1
 3b6:	1782                	slli	a5,a5,0x20
 3b8:	9381                	srli	a5,a5,0x20
 3ba:	fff7c793          	not	a5,a5
 3be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3c0:	15fd                	addi	a1,a1,-1
 3c2:	177d                	addi	a4,a4,-1
 3c4:	0005c683          	lbu	a3,0(a1)
 3c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3cc:	fee79ae3          	bne	a5,a4,3c0 <memmove+0x46>
 3d0:	bfc9                	j	3a2 <memmove+0x28>

00000000000003d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d8:	ca05                	beqz	a2,408 <memcmp+0x36>
 3da:	fff6069b          	addiw	a3,a2,-1
 3de:	1682                	slli	a3,a3,0x20
 3e0:	9281                	srli	a3,a3,0x20
 3e2:	0685                	addi	a3,a3,1
 3e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	0005c703          	lbu	a4,0(a1)
 3ee:	00e79863          	bne	a5,a4,3fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3f2:	0505                	addi	a0,a0,1
    p2++;
 3f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f6:	fed518e3          	bne	a0,a3,3e6 <memcmp+0x14>
  }
  return 0;
 3fa:	4501                	li	a0,0
 3fc:	a019                	j	402 <memcmp+0x30>
      return *p1 - *p2;
 3fe:	40e7853b          	subw	a0,a5,a4
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
  return 0;
 408:	4501                	li	a0,0
 40a:	bfe5                	j	402 <memcmp+0x30>

000000000000040c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e406                	sd	ra,8(sp)
 410:	e022                	sd	s0,0(sp)
 412:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 414:	f67ff0ef          	jal	37a <memmove>
}
 418:	60a2                	ld	ra,8(sp)
 41a:	6402                	ld	s0,0(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 420:	4885                	li	a7,1
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <exit>:
.global exit
exit:
 li a7, SYS_exit
 428:	4889                	li	a7,2
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <wait>:
.global wait
wait:
 li a7, SYS_wait
 430:	488d                	li	a7,3
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 438:	4891                	li	a7,4
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <read>:
.global read
read:
 li a7, SYS_read
 440:	4895                	li	a7,5
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <write>:
.global write
write:
 li a7, SYS_write
 448:	48c1                	li	a7,16
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <close>:
.global close
close:
 li a7, SYS_close
 450:	48d5                	li	a7,21
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <kill>:
.global kill
kill:
 li a7, SYS_kill
 458:	4899                	li	a7,6
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <exec>:
.global exec
exec:
 li a7, SYS_exec
 460:	489d                	li	a7,7
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <open>:
.global open
open:
 li a7, SYS_open
 468:	48bd                	li	a7,15
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 470:	48c5                	li	a7,17
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 478:	48c9                	li	a7,18
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 480:	48a1                	li	a7,8
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <link>:
.global link
link:
 li a7, SYS_link
 488:	48cd                	li	a7,19
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 490:	48d1                	li	a7,20
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 498:	48a5                	li	a7,9
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a0:	48a9                	li	a7,10
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a8:	48ad                	li	a7,11
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4b0:	48b1                	li	a7,12
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b8:	48b5                	li	a7,13
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c0:	48b9                	li	a7,14
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c8:	1101                	addi	sp,sp,-32
 4ca:	ec06                	sd	ra,24(sp)
 4cc:	e822                	sd	s0,16(sp)
 4ce:	1000                	addi	s0,sp,32
 4d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d4:	4605                	li	a2,1
 4d6:	fef40593          	addi	a1,s0,-17
 4da:	f6fff0ef          	jal	448 <write>
}
 4de:	60e2                	ld	ra,24(sp)
 4e0:	6442                	ld	s0,16(sp)
 4e2:	6105                	addi	sp,sp,32
 4e4:	8082                	ret

00000000000004e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e6:	7139                	addi	sp,sp,-64
 4e8:	fc06                	sd	ra,56(sp)
 4ea:	f822                	sd	s0,48(sp)
 4ec:	f426                	sd	s1,40(sp)
 4ee:	0080                	addi	s0,sp,64
 4f0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f2:	c299                	beqz	a3,4f8 <printint+0x12>
 4f4:	0805c963          	bltz	a1,586 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4f8:	2581                	sext.w	a1,a1
  neg = 0;
 4fa:	4881                	li	a7,0
 4fc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 500:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 502:	2601                	sext.w	a2,a2
 504:	00000517          	auipc	a0,0x0
 508:	5b450513          	addi	a0,a0,1460 # ab8 <digits>
 50c:	883a                	mv	a6,a4
 50e:	2705                	addiw	a4,a4,1
 510:	02c5f7bb          	remuw	a5,a1,a2
 514:	1782                	slli	a5,a5,0x20
 516:	9381                	srli	a5,a5,0x20
 518:	97aa                	add	a5,a5,a0
 51a:	0007c783          	lbu	a5,0(a5)
 51e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 522:	0005879b          	sext.w	a5,a1
 526:	02c5d5bb          	divuw	a1,a1,a2
 52a:	0685                	addi	a3,a3,1
 52c:	fec7f0e3          	bgeu	a5,a2,50c <printint+0x26>
  if(neg)
 530:	00088c63          	beqz	a7,548 <printint+0x62>
    buf[i++] = '-';
 534:	fd070793          	addi	a5,a4,-48
 538:	00878733          	add	a4,a5,s0
 53c:	02d00793          	li	a5,45
 540:	fef70823          	sb	a5,-16(a4)
 544:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 548:	02e05a63          	blez	a4,57c <printint+0x96>
 54c:	f04a                	sd	s2,32(sp)
 54e:	ec4e                	sd	s3,24(sp)
 550:	fc040793          	addi	a5,s0,-64
 554:	00e78933          	add	s2,a5,a4
 558:	fff78993          	addi	s3,a5,-1
 55c:	99ba                	add	s3,s3,a4
 55e:	377d                	addiw	a4,a4,-1
 560:	1702                	slli	a4,a4,0x20
 562:	9301                	srli	a4,a4,0x20
 564:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 568:	fff94583          	lbu	a1,-1(s2)
 56c:	8526                	mv	a0,s1
 56e:	f5bff0ef          	jal	4c8 <putc>
  while(--i >= 0)
 572:	197d                	addi	s2,s2,-1
 574:	ff391ae3          	bne	s2,s3,568 <printint+0x82>
 578:	7902                	ld	s2,32(sp)
 57a:	69e2                	ld	s3,24(sp)
}
 57c:	70e2                	ld	ra,56(sp)
 57e:	7442                	ld	s0,48(sp)
 580:	74a2                	ld	s1,40(sp)
 582:	6121                	addi	sp,sp,64
 584:	8082                	ret
    x = -xx;
 586:	40b005bb          	negw	a1,a1
    neg = 1;
 58a:	4885                	li	a7,1
    x = -xx;
 58c:	bf85                	j	4fc <printint+0x16>

000000000000058e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58e:	711d                	addi	sp,sp,-96
 590:	ec86                	sd	ra,88(sp)
 592:	e8a2                	sd	s0,80(sp)
 594:	e0ca                	sd	s2,64(sp)
 596:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 598:	0005c903          	lbu	s2,0(a1)
 59c:	26090863          	beqz	s2,80c <vprintf+0x27e>
 5a0:	e4a6                	sd	s1,72(sp)
 5a2:	fc4e                	sd	s3,56(sp)
 5a4:	f852                	sd	s4,48(sp)
 5a6:	f456                	sd	s5,40(sp)
 5a8:	f05a                	sd	s6,32(sp)
 5aa:	ec5e                	sd	s7,24(sp)
 5ac:	e862                	sd	s8,16(sp)
 5ae:	e466                	sd	s9,8(sp)
 5b0:	8b2a                	mv	s6,a0
 5b2:	8a2e                	mv	s4,a1
 5b4:	8bb2                	mv	s7,a2
  state = 0;
 5b6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5b8:	4481                	li	s1,0
 5ba:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5bc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5c4:	06c00c93          	li	s9,108
 5c8:	a005                	j	5e8 <vprintf+0x5a>
        putc(fd, c0);
 5ca:	85ca                	mv	a1,s2
 5cc:	855a                	mv	a0,s6
 5ce:	efbff0ef          	jal	4c8 <putc>
 5d2:	a019                	j	5d8 <vprintf+0x4a>
    } else if(state == '%'){
 5d4:	03598263          	beq	s3,s5,5f8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5d8:	2485                	addiw	s1,s1,1
 5da:	8726                	mv	a4,s1
 5dc:	009a07b3          	add	a5,s4,s1
 5e0:	0007c903          	lbu	s2,0(a5)
 5e4:	20090c63          	beqz	s2,7fc <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5e8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ec:	fe0994e3          	bnez	s3,5d4 <vprintf+0x46>
      if(c0 == '%'){
 5f0:	fd579de3          	bne	a5,s5,5ca <vprintf+0x3c>
        state = '%';
 5f4:	89be                	mv	s3,a5
 5f6:	b7cd                	j	5d8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5f8:	00ea06b3          	add	a3,s4,a4
 5fc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 600:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 602:	c681                	beqz	a3,60a <vprintf+0x7c>
 604:	9752                	add	a4,a4,s4
 606:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 60a:	03878f63          	beq	a5,s8,648 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 60e:	05978963          	beq	a5,s9,660 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 612:	07500713          	li	a4,117
 616:	0ee78363          	beq	a5,a4,6fc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 61a:	07800713          	li	a4,120
 61e:	12e78563          	beq	a5,a4,748 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 622:	07000713          	li	a4,112
 626:	14e78a63          	beq	a5,a4,77a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 62a:	07300713          	li	a4,115
 62e:	18e78a63          	beq	a5,a4,7c2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 632:	02500713          	li	a4,37
 636:	04e79563          	bne	a5,a4,680 <vprintf+0xf2>
        putc(fd, '%');
 63a:	02500593          	li	a1,37
 63e:	855a                	mv	a0,s6
 640:	e89ff0ef          	jal	4c8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 644:	4981                	li	s3,0
 646:	bf49                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 648:	008b8913          	addi	s2,s7,8
 64c:	4685                	li	a3,1
 64e:	4629                	li	a2,10
 650:	000ba583          	lw	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e91ff0ef          	jal	4e6 <printint>
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bfad                	j	5d8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 660:	06400793          	li	a5,100
 664:	02f68963          	beq	a3,a5,696 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 668:	06c00793          	li	a5,108
 66c:	04f68263          	beq	a3,a5,6b0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 670:	07500793          	li	a5,117
 674:	0af68063          	beq	a3,a5,714 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 678:	07800793          	li	a5,120
 67c:	0ef68263          	beq	a3,a5,760 <vprintf+0x1d2>
        putc(fd, '%');
 680:	02500593          	li	a1,37
 684:	855a                	mv	a0,s6
 686:	e43ff0ef          	jal	4c8 <putc>
        putc(fd, c0);
 68a:	85ca                	mv	a1,s2
 68c:	855a                	mv	a0,s6
 68e:	e3bff0ef          	jal	4c8 <putc>
      state = 0;
 692:	4981                	li	s3,0
 694:	b791                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 696:	008b8913          	addi	s2,s7,8
 69a:	4685                	li	a3,1
 69c:	4629                	li	a2,10
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	e43ff0ef          	jal	4e6 <printint>
        i += 1;
 6a8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
        i += 1;
 6ae:	b72d                	j	5d8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b0:	06400793          	li	a5,100
 6b4:	02f60763          	beq	a2,a5,6e2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6b8:	07500793          	li	a5,117
 6bc:	06f60963          	beq	a2,a5,72e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c0:	07800793          	li	a5,120
 6c4:	faf61ee3          	bne	a2,a5,680 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000ba583          	lw	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	e11ff0ef          	jal	4e6 <printint>
        i += 2;
 6da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 2;
 6e0:	bde5                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4685                	li	a3,1
 6e8:	4629                	li	a2,10
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	df7ff0ef          	jal	4e6 <printint>
        i += 2;
 6f4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
        i += 2;
 6fa:	bdf9                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6fc:	008b8913          	addi	s2,s7,8
 700:	4681                	li	a3,0
 702:	4629                	li	a2,10
 704:	000ba583          	lw	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	dddff0ef          	jal	4e6 <printint>
 70e:	8bca                	mv	s7,s2
      state = 0;
 710:	4981                	li	s3,0
 712:	b5d9                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 714:	008b8913          	addi	s2,s7,8
 718:	4681                	li	a3,0
 71a:	4629                	li	a2,10
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	dc5ff0ef          	jal	4e6 <printint>
        i += 1;
 726:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 1;
 72c:	b575                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	008b8913          	addi	s2,s7,8
 732:	4681                	li	a3,0
 734:	4629                	li	a2,10
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	dabff0ef          	jal	4e6 <printint>
        i += 2;
 740:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 742:	8bca                	mv	s7,s2
      state = 0;
 744:	4981                	li	s3,0
        i += 2;
 746:	bd49                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 748:	008b8913          	addi	s2,s7,8
 74c:	4681                	li	a3,0
 74e:	4641                	li	a2,16
 750:	000ba583          	lw	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	d91ff0ef          	jal	4e6 <printint>
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bdad                	j	5d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 760:	008b8913          	addi	s2,s7,8
 764:	4681                	li	a3,0
 766:	4641                	li	a2,16
 768:	000ba583          	lw	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	d79ff0ef          	jal	4e6 <printint>
        i += 1;
 772:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
        i += 1;
 778:	b585                	j	5d8 <vprintf+0x4a>
 77a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 77c:	008b8d13          	addi	s10,s7,8
 780:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 784:	03000593          	li	a1,48
 788:	855a                	mv	a0,s6
 78a:	d3fff0ef          	jal	4c8 <putc>
  putc(fd, 'x');
 78e:	07800593          	li	a1,120
 792:	855a                	mv	a0,s6
 794:	d35ff0ef          	jal	4c8 <putc>
 798:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79a:	00000b97          	auipc	s7,0x0
 79e:	31eb8b93          	addi	s7,s7,798 # ab8 <digits>
 7a2:	03c9d793          	srli	a5,s3,0x3c
 7a6:	97de                	add	a5,a5,s7
 7a8:	0007c583          	lbu	a1,0(a5)
 7ac:	855a                	mv	a0,s6
 7ae:	d1bff0ef          	jal	4c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b2:	0992                	slli	s3,s3,0x4
 7b4:	397d                	addiw	s2,s2,-1
 7b6:	fe0916e3          	bnez	s2,7a2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7ba:	8bea                	mv	s7,s10
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	6d02                	ld	s10,0(sp)
 7c0:	bd21                	j	5d8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7c2:	008b8993          	addi	s3,s7,8
 7c6:	000bb903          	ld	s2,0(s7)
 7ca:	00090f63          	beqz	s2,7e8 <vprintf+0x25a>
        for(; *s; s++)
 7ce:	00094583          	lbu	a1,0(s2)
 7d2:	c195                	beqz	a1,7f6 <vprintf+0x268>
          putc(fd, *s);
 7d4:	855a                	mv	a0,s6
 7d6:	cf3ff0ef          	jal	4c8 <putc>
        for(; *s; s++)
 7da:	0905                	addi	s2,s2,1
 7dc:	00094583          	lbu	a1,0(s2)
 7e0:	f9f5                	bnez	a1,7d4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7e2:	8bce                	mv	s7,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	bbcd                	j	5d8 <vprintf+0x4a>
          s = "(null)";
 7e8:	00000917          	auipc	s2,0x0
 7ec:	2c890913          	addi	s2,s2,712 # ab0 <malloc+0x1bc>
        for(; *s; s++)
 7f0:	02800593          	li	a1,40
 7f4:	b7c5                	j	7d4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7f6:	8bce                	mv	s7,s3
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bbf9                	j	5d8 <vprintf+0x4a>
 7fc:	64a6                	ld	s1,72(sp)
 7fe:	79e2                	ld	s3,56(sp)
 800:	7a42                	ld	s4,48(sp)
 802:	7aa2                	ld	s5,40(sp)
 804:	7b02                	ld	s6,32(sp)
 806:	6be2                	ld	s7,24(sp)
 808:	6c42                	ld	s8,16(sp)
 80a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 80c:	60e6                	ld	ra,88(sp)
 80e:	6446                	ld	s0,80(sp)
 810:	6906                	ld	s2,64(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret

0000000000000816 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 816:	715d                	addi	sp,sp,-80
 818:	ec06                	sd	ra,24(sp)
 81a:	e822                	sd	s0,16(sp)
 81c:	1000                	addi	s0,sp,32
 81e:	e010                	sd	a2,0(s0)
 820:	e414                	sd	a3,8(s0)
 822:	e818                	sd	a4,16(s0)
 824:	ec1c                	sd	a5,24(s0)
 826:	03043023          	sd	a6,32(s0)
 82a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 832:	8622                	mv	a2,s0
 834:	d5bff0ef          	jal	58e <vprintf>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6161                	addi	sp,sp,80
 83e:	8082                	ret

0000000000000840 <printf>:

void
printf(const char *fmt, ...)
{
 840:	711d                	addi	sp,sp,-96
 842:	ec06                	sd	ra,24(sp)
 844:	e822                	sd	s0,16(sp)
 846:	1000                	addi	s0,sp,32
 848:	e40c                	sd	a1,8(s0)
 84a:	e810                	sd	a2,16(s0)
 84c:	ec14                	sd	a3,24(s0)
 84e:	f018                	sd	a4,32(s0)
 850:	f41c                	sd	a5,40(s0)
 852:	03043823          	sd	a6,48(s0)
 856:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85a:	00840613          	addi	a2,s0,8
 85e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 862:	85aa                	mv	a1,a0
 864:	4505                	li	a0,1
 866:	d29ff0ef          	jal	58e <vprintf>
}
 86a:	60e2                	ld	ra,24(sp)
 86c:	6442                	ld	s0,16(sp)
 86e:	6125                	addi	sp,sp,96
 870:	8082                	ret

0000000000000872 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 872:	1141                	addi	sp,sp,-16
 874:	e422                	sd	s0,8(sp)
 876:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 878:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	00000797          	auipc	a5,0x0
 880:	7847b783          	ld	a5,1924(a5) # 1000 <freep>
 884:	a02d                	j	8ae <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 886:	4618                	lw	a4,8(a2)
 888:	9f2d                	addw	a4,a4,a1
 88a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	6310                	ld	a2,0(a4)
 892:	a83d                	j	8d0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 894:	ff852703          	lw	a4,-8(a0)
 898:	9f31                	addw	a4,a4,a2
 89a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 89c:	ff053683          	ld	a3,-16(a0)
 8a0:	a091                	j	8e4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a2:	6398                	ld	a4,0(a5)
 8a4:	00e7e463          	bltu	a5,a4,8ac <free+0x3a>
 8a8:	00e6ea63          	bltu	a3,a4,8bc <free+0x4a>
{
 8ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	fed7fae3          	bgeu	a5,a3,8a2 <free+0x30>
 8b2:	6398                	ld	a4,0(a5)
 8b4:	00e6e463          	bltu	a3,a4,8bc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b8:	fee7eae3          	bltu	a5,a4,8ac <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8bc:	ff852583          	lw	a1,-8(a0)
 8c0:	6390                	ld	a2,0(a5)
 8c2:	02059813          	slli	a6,a1,0x20
 8c6:	01c85713          	srli	a4,a6,0x1c
 8ca:	9736                	add	a4,a4,a3
 8cc:	fae60de3          	beq	a2,a4,886 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d4:	4790                	lw	a2,8(a5)
 8d6:	02061593          	slli	a1,a2,0x20
 8da:	01c5d713          	srli	a4,a1,0x1c
 8de:	973e                	add	a4,a4,a5
 8e0:	fae68ae3          	beq	a3,a4,894 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8e4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70f73d23          	sd	a5,1818(a4) # 1000 <freep>
}
 8ee:	6422                	ld	s0,8(sp)
 8f0:	0141                	addi	sp,sp,16
 8f2:	8082                	ret

00000000000008f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f4:	7139                	addi	sp,sp,-64
 8f6:	fc06                	sd	ra,56(sp)
 8f8:	f822                	sd	s0,48(sp)
 8fa:	f426                	sd	s1,40(sp)
 8fc:	ec4e                	sd	s3,24(sp)
 8fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 900:	02051493          	slli	s1,a0,0x20
 904:	9081                	srli	s1,s1,0x20
 906:	04bd                	addi	s1,s1,15
 908:	8091                	srli	s1,s1,0x4
 90a:	0014899b          	addiw	s3,s1,1
 90e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 910:	00000517          	auipc	a0,0x0
 914:	6f053503          	ld	a0,1776(a0) # 1000 <freep>
 918:	c915                	beqz	a0,94c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91c:	4798                	lw	a4,8(a5)
 91e:	08977a63          	bgeu	a4,s1,9b2 <malloc+0xbe>
 922:	f04a                	sd	s2,32(sp)
 924:	e852                	sd	s4,16(sp)
 926:	e456                	sd	s5,8(sp)
 928:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 92a:	8a4e                	mv	s4,s3
 92c:	0009871b          	sext.w	a4,s3
 930:	6685                	lui	a3,0x1
 932:	00d77363          	bgeu	a4,a3,938 <malloc+0x44>
 936:	6a05                	lui	s4,0x1
 938:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 940:	00000917          	auipc	s2,0x0
 944:	6c090913          	addi	s2,s2,1728 # 1000 <freep>
  if(p == (char*)-1)
 948:	5afd                	li	s5,-1
 94a:	a081                	j	98a <malloc+0x96>
 94c:	f04a                	sd	s2,32(sp)
 94e:	e852                	sd	s4,16(sp)
 950:	e456                	sd	s5,8(sp)
 952:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 954:	00000797          	auipc	a5,0x0
 958:	6bc78793          	addi	a5,a5,1724 # 1010 <base>
 95c:	00000717          	auipc	a4,0x0
 960:	6af73223          	sd	a5,1700(a4) # 1000 <freep>
 964:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 966:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 96a:	b7c1                	j	92a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 96c:	6398                	ld	a4,0(a5)
 96e:	e118                	sd	a4,0(a0)
 970:	a8a9                	j	9ca <malloc+0xd6>
  hp->s.size = nu;
 972:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 976:	0541                	addi	a0,a0,16
 978:	efbff0ef          	jal	872 <free>
  return freep;
 97c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 980:	c12d                	beqz	a0,9e2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 984:	4798                	lw	a4,8(a5)
 986:	02977263          	bgeu	a4,s1,9aa <malloc+0xb6>
    if(p == freep)
 98a:	00093703          	ld	a4,0(s2)
 98e:	853e                	mv	a0,a5
 990:	fef719e3          	bne	a4,a5,982 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 994:	8552                	mv	a0,s4
 996:	b1bff0ef          	jal	4b0 <sbrk>
  if(p == (char*)-1)
 99a:	fd551ce3          	bne	a0,s5,972 <malloc+0x7e>
        return 0;
 99e:	4501                	li	a0,0
 9a0:	7902                	ld	s2,32(sp)
 9a2:	6a42                	ld	s4,16(sp)
 9a4:	6aa2                	ld	s5,8(sp)
 9a6:	6b02                	ld	s6,0(sp)
 9a8:	a03d                	j	9d6 <malloc+0xe2>
 9aa:	7902                	ld	s2,32(sp)
 9ac:	6a42                	ld	s4,16(sp)
 9ae:	6aa2                	ld	s5,8(sp)
 9b0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b2:	fae48de3          	beq	s1,a4,96c <malloc+0x78>
        p->s.size -= nunits;
 9b6:	4137073b          	subw	a4,a4,s3
 9ba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9bc:	02071693          	slli	a3,a4,0x20
 9c0:	01c6d713          	srli	a4,a3,0x1c
 9c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ca:	00000717          	auipc	a4,0x0
 9ce:	62a73b23          	sd	a0,1590(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d2:	01078513          	addi	a0,a5,16
  }
}
 9d6:	70e2                	ld	ra,56(sp)
 9d8:	7442                	ld	s0,48(sp)
 9da:	74a2                	ld	s1,40(sp)
 9dc:	69e2                	ld	s3,24(sp)
 9de:	6121                	addi	sp,sp,64
 9e0:	8082                	ret
 9e2:	7902                	ld	s2,32(sp)
 9e4:	6a42                	ld	s4,16(sp)
 9e6:	6aa2                	ld	s5,8(sp)
 9e8:	6b02                	ld	s6,0(sp)
 9ea:	b7f5                	j	9d6 <malloc+0xe2>
