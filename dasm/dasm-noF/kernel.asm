       0:	fc102573		csrr	a0,unknown-csr
       4:	00000597		auipc	a1,0x0
       8:	13858593		addi	a1,a1,312
       c:	00b5106b		Unknown instruction:   B5106B 
      10:	12c000ef		jal	ra,0x13C
      14:	00100513		li	a0,1
      18:	0005006b		Unknown instruction:    5006B 
      1c:	fc102573		csrr	a0,unknown-csr
      20:	00000597		auipc	a1,0x0
      24:	16858593		addi	a1,a1,360
      28:	00b5106b		Unknown instruction:   B5106B 
      2c:	15c000ef		jal	ra,0x188
      30:	00100513		li	a0,1
      34:	0005006b		Unknown instruction:    5006B 
      38:	00001517		auipc	a0,0x1
      3c:	3fc50513		addi	a0,a0,1020
      40:	00001617		auipc	a2,0x1
      44:	47460613		addi	a2,a2,1140
      48:	40a60633		sub	a2,a2,a0
      4c:	00000593		li	a1,0
      50:	0b5000ef		jal	ra,0x904
      54:	00000517		auipc	a0,0x0
      58:	22450513		addi	a0,a0,548
      5c:	6f0000ef		jal	ra,0x74C
      60:	184000ef		jal	ra,0x1E4
      64:	03c000ef		jal	ra,0xA0
      68:	0040006f		j	0x6C
      6c:	ff010113		addi	sp,sp,-16
      70:	00000593		li	a1,0
      74:	00812423		sw	s0,8(sp)
      78:	00112623		sw	ra,12(sp)
      7c:	00050413		mv	s0,a0
      80:	1fd000ef		jal	ra,0xA7C
      84:	00001517		auipc	a0,0x1
      88:	3ac52503		lw	a0,940(a0)
      8c:	03c52783		lw	a5,60(a0)
      90:	00078463		beqz	a5,0x98
      94:	000780e7		jalr	a5
      98:	00040513		mv	a0,s0
      9c:	08c000ef		jal	ra,0x128
      a0:	7ffff7b7		lui	a5,0x7ffff
      a4:	0007a503		lw	a0,0(a5)
      a8:	800005b7		lui	a1,0x80000
      ac:	7ffff637		lui	a2,0x7ffff
      b0:	0d058593		addi	a1,a1,208
      b4:	32c0006f		j	0x3E0
      b8:	00000793		li	a5,0
      bc:	00078863		beqz	a5,0xcc
      c0:	00000517		auipc	a0,0x0
      c4:	1b850513		addi	a0,a0,440
      c8:	6840006f		j	0x74C
      cc:	00008067		ret
      d0:	0045a683		lw	a3,4(a1)
      d4:	0085a603		lw	a2,8(a1)
      d8:	00c5a703		lw	a4,12(a1)
      dc:	02d50533		mul	a0,a0,a3
      e0:	0105a803		lw	a6,16(a1)
      e4:	04068063		beqz	a3,0x124
      e8:	00a686b3		add	a3,a3,a0
      ec:	00269693		slli	a3,a3,0x2
      f0:	00251513		slli	a0,a0,0x2
      f4:	00c507b3		add	a5,a0,a2
      f8:	00c686b3		add	a3,a3,a2
      fc:	40c80833		sub	a6,a6,a2
     100:	40c70533		sub	a0,a4,a2
     104:	00f50733		add	a4,a0,a5
     108:	0007a583		lw	a1,0(a5)
     10c:	00072703		lw	a4,0(a4)
     110:	00f80633		add	a2,a6,a5
     114:	00478793		addi	a5,a5,4
     118:	00b70733		add	a4,a4,a1
     11c:	00e62023		sw	a4,0(a2)
     120:	fef692e3		bne	a3,a5,0x104
     124:	00008067		ret
     128:	00050413		mv	s0,a0
     12c:	40c000ef		jal	ra,0x538
     130:	00040193		mv	gp,s0
     134:	00000513		li	a0,0
     138:	0005006b		Unknown instruction:    5006B 
     13c:	fff00513		li	a0,-1
     140:	0005006b		Unknown instruction:    5006B 
     144:	00001197		auipc	gp,0x1
     148:	6c418193		addi	gp,gp,1732
     14c:	ff000137		lui	sp,0xff000
     150:	cc102573		csrr	a0,unknown-csr
     154:	00a51593		slli	a1,a0,0xa
     158:	40b10133		sub	sp,sp,a1
     15c:	00000593		li	a1,0
     160:	02b50533		mul	a0,a0,a1
     164:	00001217		auipc	tp,0x1
     168:	38f20213		addi	tp,tp,911
     16c:	00a20233		add	tp,tp,a0
     170:	fc027213		andi	tp,tp,-64
     174:	cc3026f3		csrr	a3,unknown-csr
     178:	00068663		beqz	a3,0x184
     17c:	00000513		li	a0,0
     180:	0005006b		Unknown instruction:    5006B 
     184:	00008067		ret
     188:	ff010113		addi	sp,sp,-16
     18c:	00112623		sw	ra,12(sp)
     190:	00812423		sw	s0,8(sp)
     194:	fff00793		li	a5,-1
     198:	0007806b		Unknown instruction:    7806B 
     19c:	00000613		li	a2,0
     1a0:	00020513		mv	a0,tp
     1a4:	00001597		auipc	a1,0x1
     1a8:	e5c58593		addi	a1,a1,-420
     1ac:	00020413		mv	s0,tp
     1b0:	5b0000ef		jal	ra,0x760
     1b4:	00000513		li	a0,0
     1b8:	00000613		li	a2,0
     1bc:	00000593		li	a1,0
     1c0:	00a40533		add	a0,s0,a0
     1c4:	740000ef		jal	ra,0x904
     1c8:	cc3027f3		csrr	a5,unknown-csr
     1cc:	0017b793		seqz	a5,a5
     1d0:	0007806b		Unknown instruction:    7806B 
     1d4:	00c12083		lw	ra,12(sp)
     1d8:	00812403		lw	s0,8(sp)
     1dc:	01010113		addi	sp,sp,16
     1e0:	00008067		ret
     1e4:	ff010113		addi	sp,sp,-16
     1e8:	00812423		sw	s0,8(sp)
     1ec:	01212023		sw	s2,0(sp)
     1f0:	00001797		auipc	a5,0x1
     1f4:	e1078793		addi	a5,a5,-496
     1f8:	00001417		auipc	s0,0x1
     1fc:	e0840413		addi	s0,s0,-504
     200:	00112623		sw	ra,12(sp)
     204:	00912223		sw	s1,4(sp)
     208:	40878933		sub	s2,a5,s0
     20c:	02878063		beq	a5,s0,0x22c
     210:	40295913		srai	s2,s2,0x2
     214:	00000493		li	s1,0
     218:	00042783		lw	a5,0(s0)
     21c:	00148493		addi	s1,s1,1
     220:	00440413		addi	s0,s0,4
     224:	000780e7		jalr	a5
     228:	ff24e8e3		bltu	s1,s2,0x218
     22c:	00001797		auipc	a5,0x1
     230:	dd878793		addi	a5,a5,-552
     234:	00001417		auipc	s0,0x1
     238:	dcc40413		addi	s0,s0,-564
     23c:	40878933		sub	s2,a5,s0
     240:	40295913		srai	s2,s2,0x2
     244:	00878e63		beq	a5,s0,0x260
     248:	00000493		li	s1,0
     24c:	00042783		lw	a5,0(s0)
     250:	00148493		addi	s1,s1,1
     254:	00440413		addi	s0,s0,4
     258:	000780e7		jalr	a5
     25c:	ff24e8e3		bltu	s1,s2,0x24c
     260:	00c12083		lw	ra,12(sp)
     264:	00812403		lw	s0,8(sp)
     268:	00412483		lw	s1,4(sp)
     26c:	00012903		lw	s2,0(sp)
     270:	01010113		addi	sp,sp,16
     274:	00008067		ret
     278:	ff010113		addi	sp,sp,-16
     27c:	00812423		sw	s0,8(sp)
     280:	00001797		auipc	a5,0x1
     284:	d8478793		addi	a5,a5,-636
     288:	00001417		auipc	s0,0x1
     28c:	d7c40413		addi	s0,s0,-644
     290:	40f40433		sub	s0,s0,a5
     294:	00912223		sw	s1,4(sp)
     298:	00112623		sw	ra,12(sp)
     29c:	40245493		srai	s1,s0,0x2
     2a0:	02048063		beqz	s1,0x2c0
     2a4:	ffc40413		addi	s0,s0,-4
     2a8:	00f40433		add	s0,s0,a5
     2ac:	00042783		lw	a5,0(s0)
     2b0:	fff48493		addi	s1,s1,-1
     2b4:	ffc40413		addi	s0,s0,-4
     2b8:	000780e7		jalr	a5
     2bc:	fe0498e3		bnez	s1,0x2ac
     2c0:	00c12083		lw	ra,12(sp)
     2c4:	00812403		lw	s0,8(sp)
     2c8:	00412483		lw	s1,4(sp)
     2cc:	01010113		addi	sp,sp,16
     2d0:	00008067		ret
     2d4:	ff010113		addi	sp,sp,-16
     2d8:	00112623		sw	ra,12(sp)
     2dc:	00812423		sw	s0,8(sp)
     2e0:	00912223		sw	s1,4(sp)
     2e4:	01212023		sw	s2,0(sp)
     2e8:	cc502673		csrr	a2,unknown-csr
     2ec:	cc302773		csrr	a4,unknown-csr
     2f0:	cc0026f3		csrr	a3,unknown-csr
     2f4:	fc0025f3		csrr	a1,unknown-csr
     2f8:	00001797		auipc	a5,0x1
     2fc:	13c78793		addi	a5,a5,316
     300:	00261613		slli	a2,a2,0x2
     304:	00c787b3		add	a5,a5,a2
     308:	0007a483		lw	s1,0(a5)
     30c:	0104a783		lw	a5,16(s1)
     310:	00c4a603		lw	a2,12(s1)
     314:	00f72933		slt	s2,a4,a5
     318:	02e60433		mul	s0,a2,a4
     31c:	00c90933		add	s2,s2,a2
     320:	00f75463		bge	a4,a5,0x328
     324:	00070793		mv	a5,a4
     328:	00f40433		add	s0,s0,a5
     32c:	0084a703		lw	a4,8(s1)
     330:	02b40433		mul	s0,s0,a1
     334:	02d907b3		mul	a5,s2,a3
     338:	00e40433		add	s0,s0,a4
     33c:	00f40433		add	s0,s0,a5
     340:	00890933		add	s2,s2,s0
     344:	01245e63		bge	s0,s2,0x360
     348:	0004a783		lw	a5,0(s1)
     34c:	0044a583		lw	a1,4(s1)
     350:	00040513		mv	a0,s0
     354:	00140413		addi	s0,s0,1
     358:	000780e7		jalr	a5
     35c:	fe8916e3		bne	s2,s0,0x348
     360:	0144a703		lw	a4,20(s1)
     364:	00000793		li	a5,0
     368:	00e7c06b		Unknown instruction:   E7C06B 
     36c:	00c12083		lw	ra,12(sp)
     370:	00812403		lw	s0,8(sp)
     374:	00412483		lw	s1,4(sp)
     378:	00012903		lw	s2,0(sp)
     37c:	01010113		addi	sp,sp,16
     380:	00008067		ret
     384:	cc502773		csrr	a4,unknown-csr
     388:	cc202573		csrr	a0,unknown-csr
     38c:	00001797		auipc	a5,0x1
     390:	0a878793		addi	a5,a5,168
     394:	00271713		slli	a4,a4,0x2
     398:	00e787b3		add	a5,a5,a4
     39c:	0007a783		lw	a5,0(a5)
     3a0:	0087a683		lw	a3,8(a5)
     3a4:	0007a703		lw	a4,0(a5)
     3a8:	0047a583		lw	a1,4(a5)
     3ac:	00d50533		add	a0,a0,a3
     3b0:	00070067		jr	a4
     3b4:	ff010113		addi	sp,sp,-16
     3b8:	00112623		sw	ra,12(sp)
     3bc:	fff00793		li	a5,-1
     3c0:	0007806b		Unknown instruction:    7806B 
     3c4:	f11ff0ef		jal	ra,0x2D4
     3c8:	cc3027f3		csrr	a5,unknown-csr
     3cc:	0017b793		seqz	a5,a5
     3d0:	0007806b		Unknown instruction:    7806B 
     3d4:	00c12083		lw	ra,12(sp)
     3d8:	01010113		addi	sp,sp,16
     3dc:	00008067		ret
     3e0:	fd010113		addi	sp,sp,-48
     3e4:	02112623		sw	ra,44(sp)
     3e8:	02812423		sw	s0,40(sp)
     3ec:	02912223		sw	s1,36(sp)
     3f0:	03212023		sw	s2,32(sp)
     3f4:	fc2026f3		csrr	a3,unknown-csr
     3f8:	fc1028f3		csrr	a7,unknown-csr
     3fc:	fc0024f3		csrr	s1,unknown-csr
     400:	cc5027f3		csrr	a5,unknown-csr
     404:	01f00713		li	a4,31
     408:	08f74863		blt	a4,a5,0x498
     40c:	03148833		mul	a6,s1,a7
     410:	00100713		li	a4,1
     414:	00a85463		bge	a6,a0,0x41c
     418:	03054733		div	a4,a0,a6
     41c:	08e6ca63		blt	a3,a4,0x4b0
     420:	06e7dc63		bge	a5,a4,0x498
     424:	fff68693		addi	a3,a3,-1
     428:	02e54333		div	t1,a0,a4
     42c:	00030813		mv	a6,t1
     430:	00f69663		bne	a3,a5,0x43c
     434:	02e56533		rem	a0,a0,a4
     438:	00650833		add	a6,a0,t1
     43c:	02984933		div	s2,a6,s1
     440:	02986433		rem	s0,a6,s1
     444:	07194c63		blt	s2,a7,0x4bc
     448:	00100513		li	a0,1
     44c:	031946b3		div	a3,s2,a7
     450:	00068663		beqz	a3,0x45c
     454:	00068513		mv	a0,a3
     458:	031966b3		rem	a3,s2,a7
     45c:	00001717		auipc	a4,0x1
     460:	fd870713		addi	a4,a4,-40
     464:	00b12423		sw	a1,8(sp)
     468:	00c12623		sw	a2,12(sp)
     46c:	00a12a23		sw	a0,20(sp)
     470:	00d12c23		sw	a3,24(sp)
     474:	00012e23		sw	zero,28(sp)
     478:	02f30333		mul	t1,t1,a5
     47c:	00279793		slli	a5,a5,0x2
     480:	00f707b3		add	a5,a4,a5
     484:	00810713		addi	a4,sp,8
     488:	00e7a023		sw	a4,0(a5)
     48c:	00612823		sw	t1,16(sp)
     490:	03204c63		bgtz	s2,0x4c8
     494:	06041663		bnez	s0,0x500
     498:	02c12083		lw	ra,44(sp)
     49c:	02812403		lw	s0,40(sp)
     4a0:	02412483		lw	s1,36(sp)
     4a4:	02012903		lw	s2,32(sp)
     4a8:	03010113		addi	sp,sp,48
     4ac:	00008067		ret
     4b0:	00068713		mv	a4,a3
     4b4:	f6e7c8e3		blt	a5,a4,0x424
     4b8:	fe1ff06f		j	0x498
     4bc:	00000693		li	a3,0
     4c0:	00100513		li	a0,1
     4c4:	f99ff06f		j	0x45C
     4c8:	00090793		mv	a5,s2
     4cc:	0128d463		bge	a7,s2,0x4d4
     4d0:	00088793		mv	a5,a7
     4d4:	00f12e23		sw	a5,28(sp)
     4d8:	00000717		auipc	a4,0x0
     4dc:	edc70713		addi	a4,a4,-292
     4e0:	00e7906b		Unknown instruction:   E7906B 
     4e4:	fff00793		li	a5,-1
     4e8:	0007806b		Unknown instruction:    7806B 
     4ec:	de9ff0ef		jal	ra,0x2D4
     4f0:	cc3027f3		csrr	a5,unknown-csr
     4f4:	0017b793		seqz	a5,a5
     4f8:	0007806b		Unknown instruction:    7806B 
     4fc:	f8040ee3		beqz	s0,0x498
     500:	02990933		mul	s2,s2,s1
     504:	00100493		li	s1,1
     508:	00849833		sll	a6,s1,s0
     50c:	fff80813		addi	a6,a6,-1
     510:	01212823		sw	s2,16(sp)
     514:	0008006b		Unknown instruction:    8006B 
     518:	e6dff0ef		jal	ra,0x384
     51c:	0004806b		Unknown instruction:    4806B 
     520:	02c12083		lw	ra,44(sp)
     524:	02812403		lw	s0,40(sp)
     528:	02412483		lw	s1,36(sp)
     52c:	02012903		lw	s2,32(sp)
     530:	03010113		addi	sp,sp,48
     534:	00008067		ret
     538:	cc5027f3		csrr	a5,unknown-csr
     53c:	00ff0737		lui	a4,0xff0
     540:	00e787b3		add	a5,a5,a4
     544:	00879793		slli	a5,a5,0x8
     548:	b0002773		csrr	a4,mcycle
     54c:	00e7a023		sw	a4,0(a5)
     550:	b0102773		csrr	a4,unknown-csr
     554:	00e7a223		sw	a4,4(a5)
     558:	b0202773		csrr	a4,minstret
     55c:	00e7a423		sw	a4,8(a5)
     560:	b0302773		csrr	a4,mhpmcounter3
     564:	00e7a623		sw	a4,12(a5)
     568:	b0402773		csrr	a4,mhpmcounter4
     56c:	00e7a823		sw	a4,16(a5)
     570:	b0502773		csrr	a4,mhpmcounter5
     574:	00e7aa23		sw	a4,20(a5)
     578:	b0602773		csrr	a4,mhpmcounter6
     57c:	00e7ac23		sw	a4,24(a5)
     580:	b0702773		csrr	a4,mhpmcounter7
     584:	00e7ae23		sw	a4,28(a5)
     588:	b0802773		csrr	a4,mhpmcounter8
     58c:	02e7a023		sw	a4,32(a5)
     590:	b0902773		csrr	a4,mhpmcounter9
     594:	02e7a223		sw	a4,36(a5)
     598:	b0a02773		csrr	a4,mhpmcounter10
     59c:	02e7a423		sw	a4,40(a5)
     5a0:	b0b02773		csrr	a4,mhpmcounter11
     5a4:	02e7a623		sw	a4,44(a5)
     5a8:	b0c02773		csrr	a4,mhpmcounter12
     5ac:	02e7a823		sw	a4,48(a5)
     5b0:	b0d02773		csrr	a4,mhpmcounter13
     5b4:	02e7aa23		sw	a4,52(a5)
     5b8:	b0e02773		csrr	a4,mhpmcounter14
     5bc:	02e7ac23		sw	a4,56(a5)
     5c0:	b0f02773		csrr	a4,mhpmcounter15
     5c4:	02e7ae23		sw	a4,60(a5)
     5c8:	b1002773		csrr	a4,mhpmcounter16
     5cc:	04e7a023		sw	a4,64(a5)
     5d0:	b1102773		csrr	a4,mhpmcounter17
     5d4:	04e7a223		sw	a4,68(a5)
     5d8:	b1202773		csrr	a4,mhpmcounter18
     5dc:	04e7a423		sw	a4,72(a5)
     5e0:	b1302773		csrr	a4,mhpmcounter19
     5e4:	04e7a623		sw	a4,76(a5)
     5e8:	b1402773		csrr	a4,mhpmcounter20
     5ec:	04e7a823		sw	a4,80(a5)
     5f0:	b1502773		csrr	a4,mhpmcounter21
     5f4:	04e7aa23		sw	a4,84(a5)
     5f8:	b1602773		csrr	a4,mhpmcounter22
     5fc:	04e7ac23		sw	a4,88(a5)
     600:	b1702773		csrr	a4,mhpmcounter23
     604:	04e7ae23		sw	a4,92(a5)
     608:	b1802773		csrr	a4,mhpmcounter24
     60c:	06e7a023		sw	a4,96(a5)
     610:	b1902773		csrr	a4,mhpmcounter25
     614:	06e7a223		sw	a4,100(a5)
     618:	b1a02773		csrr	a4,mhpmcounter26
     61c:	06e7a423		sw	a4,104(a5)
     620:	b1b02773		csrr	a4,mhpmcounter27
     624:	06e7a623		sw	a4,108(a5)
     628:	b1c02773		csrr	a4,mhpmcounter28
     62c:	06e7a823		sw	a4,112(a5)
     630:	b1d02773		csrr	a4,mhpmcounter29
     634:	06e7aa23		sw	a4,116(a5)
     638:	b1e02773		csrr	a4,mhpmcounter30
     63c:	06e7ac23		sw	a4,120(a5)
     640:	b1f02773		csrr	a4,mhpmcounter31
     644:	06e7ae23		sw	a4,124(a5)
     648:	b8002773		csrr	a4,mcycleh
     64c:	08e7a023		sw	a4,128(a5)
     650:	b8102773		csrr	a4,unknown-csr
     654:	08e7a223		sw	a4,132(a5)
     658:	b8202773		csrr	a4,minstreth
     65c:	08e7a423		sw	a4,136(a5)
     660:	b8302773		csrr	a4,mhpmcounter3h
     664:	08e7a623		sw	a4,140(a5)
     668:	b8402773		csrr	a4,mhpmcounter4h
     66c:	08e7a823		sw	a4,144(a5)
     670:	b8502773		csrr	a4,mhpmcounter5h
     674:	08e7aa23		sw	a4,148(a5)
     678:	b8602773		csrr	a4,mhpmcounter6h
     67c:	08e7ac23		sw	a4,152(a5)
     680:	b8702773		csrr	a4,mhpmcounter7h
     684:	08e7ae23		sw	a4,156(a5)
     688:	b8802773		csrr	a4,mhpmcounter8h
     68c:	0ae7a023		sw	a4,160(a5)
     690:	b8902773		csrr	a4,mhpmcounter9h
     694:	0ae7a223		sw	a4,164(a5)
     698:	b8a02773		csrr	a4,mhpmcounter10h
     69c:	0ae7a423		sw	a4,168(a5)
     6a0:	b8b02773		csrr	a4,mhpmcounter11h
     6a4:	0ae7a623		sw	a4,172(a5)
     6a8:	b8c02773		csrr	a4,mhpmcounter12h
     6ac:	0ae7a823		sw	a4,176(a5)
     6b0:	b8d02773		csrr	a4,mhpmcounter13h
     6b4:	0ae7aa23		sw	a4,180(a5)
     6b8:	b8e02773		csrr	a4,mhpmcounter14h
     6bc:	0ae7ac23		sw	a4,184(a5)
     6c0:	b8f02773		csrr	a4,mhpmcounter15h
     6c4:	0ae7ae23		sw	a4,188(a5)
     6c8:	b9002773		csrr	a4,mhpmcounter16h
     6cc:	0ce7a023		sw	a4,192(a5)
     6d0:	b9102773		csrr	a4,mhpmcounter17h
     6d4:	0ce7a223		sw	a4,196(a5)
     6d8:	b9202773		csrr	a4,mhpmcounter18h
     6dc:	0ce7a423		sw	a4,200(a5)
     6e0:	b9302773		csrr	a4,mhpmcounter19h
     6e4:	0ce7a623		sw	a4,204(a5)
     6e8:	b9402773		csrr	a4,mhpmcounter20h
     6ec:	0ce7a823		sw	a4,208(a5)
     6f0:	b9502773		csrr	a4,mhpmcounter21h
     6f4:	0ce7aa23		sw	a4,212(a5)
     6f8:	b9602773		csrr	a4,mhpmcounter22h
     6fc:	0ce7ac23		sw	a4,216(a5)
     700:	b9702773		csrr	a4,mhpmcounter23h
     704:	0ce7ae23		sw	a4,220(a5)
     708:	b9802773		csrr	a4,mhpmcounter24h
     70c:	0ee7a023		sw	a4,224(a5)
     710:	b9902773		csrr	a4,mhpmcounter25h
     714:	0ee7a223		sw	a4,228(a5)
     718:	b9a02773		csrr	a4,mhpmcounter26h
     71c:	0ee7a423		sw	a4,232(a5)
     720:	b9b02773		csrr	a4,mhpmcounter27h
     724:	0ee7a623		sw	a4,236(a5)
     728:	b9c02773		csrr	a4,mhpmcounter28h
     72c:	0ee7a823		sw	a4,240(a5)
     730:	b9d02773		csrr	a4,mhpmcounter29h
     734:	0ee7aa23		sw	a4,244(a5)
     738:	b9e02773		csrr	a4,mhpmcounter30h
     73c:	0ee7ac23		sw	a4,248(a5)
     740:	b9f02773		csrr	a4,mhpmcounter31h
     744:	0ee7ae23		sw	a4,252(a5)
     748:	00008067		ret
     74c:	00050593		mv	a1,a0
     750:	00000693		li	a3,0
     754:	00000613		li	a2,0
     758:	00000513		li	a0,0
     75c:	2840006f		j	0x9E0
     760:	00b547b3		xor	a5,a0,a1
     764:	0037f793		andi	a5,a5,3
     768:	00c508b3		add	a7,a0,a2
     76c:	06079463		bnez	a5,0x7d4
     770:	00300793		li	a5,3
     774:	06c7f063		bgeu	a5,a2,0x7d4
     778:	00357793		andi	a5,a0,3
     77c:	00050713		mv	a4,a0
     780:	06079a63		bnez	a5,0x7f4
     784:	ffc8f613		andi	a2,a7,-4
     788:	40e606b3		sub	a3,a2,a4
     78c:	02000793		li	a5,32
     790:	08d7ce63		blt	a5,a3,0x82c
     794:	00058693		mv	a3,a1
     798:	00070793		mv	a5,a4
     79c:	02c77863		bgeu	a4,a2,0x7cc
     7a0:	0006a803		lw	a6,0(a3)
     7a4:	00478793		addi	a5,a5,4
     7a8:	00468693		addi	a3,a3,4
     7ac:	ff07ae23		sw	a6,-4(a5)
     7b0:	fec7e8e3		bltu	a5,a2,0x7a0
     7b4:	fff60793		addi	a5,a2,-1
     7b8:	40e787b3		sub	a5,a5,a4
     7bc:	ffc7f793		andi	a5,a5,-4
     7c0:	00478793		addi	a5,a5,4
     7c4:	00f70733		add	a4,a4,a5
     7c8:	00f585b3		add	a1,a1,a5
     7cc:	01176863		bltu	a4,a7,0x7dc
     7d0:	00008067		ret
     7d4:	00050713		mv	a4,a0
     7d8:	05157863		bgeu	a0,a7,0x828
     7dc:	0005c783		lbu	a5,0(a1)
     7e0:	00170713		addi	a4,a4,1
     7e4:	00158593		addi	a1,a1,1
     7e8:	fef70fa3		sb	a5,-1(a4)
     7ec:	fee898e3		bne	a7,a4,0x7dc
     7f0:	00008067		ret
     7f4:	0005c683		lbu	a3,0(a1)
     7f8:	00170713		addi	a4,a4,1
     7fc:	00377793		andi	a5,a4,3
     800:	fed70fa3		sb	a3,-1(a4)
     804:	00158593		addi	a1,a1,1
     808:	f6078ee3		beqz	a5,0x784
     80c:	0005c683		lbu	a3,0(a1)
     810:	00170713		addi	a4,a4,1
     814:	00377793		andi	a5,a4,3
     818:	fed70fa3		sb	a3,-1(a4)
     81c:	00158593		addi	a1,a1,1
     820:	fc079ae3		bnez	a5,0x7f4
     824:	f61ff06f		j	0x784
     828:	00008067		ret
     82c:	ff010113		addi	sp,sp,-16
     830:	00812623		sw	s0,12(sp)
     834:	02000413		li	s0,32
     838:	0005a383		lw	t2,0(a1)
     83c:	0045a283		lw	t0,4(a1)
     840:	0085af83		lw	t6,8(a1)
     844:	00c5af03		lw	t5,12(a1)
     848:	0105ae83		lw	t4,16(a1)
     84c:	0145ae03		lw	t3,20(a1)
     850:	0185a303		lw	t1,24(a1)
     854:	01c5a803		lw	a6,28(a1)
     858:	0205a683		lw	a3,32(a1)
     85c:	02470713		addi	a4,a4,36
     860:	40e607b3		sub	a5,a2,a4
     864:	fc772e23		sw	t2,-36(a4)
     868:	fe572023		sw	t0,-32(a4)
     86c:	fff72223		sw	t6,-28(a4)
     870:	ffe72423		sw	t5,-24(a4)
     874:	ffd72623		sw	t4,-20(a4)
     878:	ffc72823		sw	t3,-16(a4)
     87c:	fe672a23		sw	t1,-12(a4)
     880:	ff072c23		sw	a6,-8(a4)
     884:	fed72e23		sw	a3,-4(a4)
     888:	02458593		addi	a1,a1,36
     88c:	faf446e3		blt	s0,a5,0x838
     890:	00058693		mv	a3,a1
     894:	00070793		mv	a5,a4
     898:	02c77863		bgeu	a4,a2,0x8c8
     89c:	0006a803		lw	a6,0(a3)
     8a0:	00478793		addi	a5,a5,4
     8a4:	00468693		addi	a3,a3,4
     8a8:	ff07ae23		sw	a6,-4(a5)
     8ac:	fec7e8e3		bltu	a5,a2,0x89c
     8b0:	fff60793		addi	a5,a2,-1
     8b4:	40e787b3		sub	a5,a5,a4
     8b8:	ffc7f793		andi	a5,a5,-4
     8bc:	00478793		addi	a5,a5,4
     8c0:	00f70733		add	a4,a4,a5
     8c4:	00f585b3		add	a1,a1,a5
     8c8:	01176863		bltu	a4,a7,0x8d8
     8cc:	00c12403		lw	s0,12(sp)
     8d0:	01010113		addi	sp,sp,16
     8d4:	00008067		ret
     8d8:	0005c783		lbu	a5,0(a1)
     8dc:	00170713		addi	a4,a4,1
     8e0:	00158593		addi	a1,a1,1
     8e4:	fef70fa3		sb	a5,-1(a4)
     8e8:	fee882e3		beq	a7,a4,0x8cc
     8ec:	0005c783		lbu	a5,0(a1)
     8f0:	00170713		addi	a4,a4,1
     8f4:	00158593		addi	a1,a1,1
     8f8:	fef70fa3		sb	a5,-1(a4)
     8fc:	fce89ee3		bne	a7,a4,0x8d8
     900:	fcdff06f		j	0x8CC
     904:	00f00313		li	t1,15
     908:	00050713		mv	a4,a0
     90c:	02c37e63		bgeu	t1,a2,0x948
     910:	00f77793		andi	a5,a4,15
     914:	0a079063		bnez	a5,0x9b4
     918:	08059263		bnez	a1,0x99c
     91c:	ff067693		andi	a3,a2,-16
     920:	00f67613		andi	a2,a2,15
     924:	00e686b3		add	a3,a3,a4
     928:	00b72023		sw	a1,0(a4)
     92c:	00b72223		sw	a1,4(a4)
     930:	00b72423		sw	a1,8(a4)
     934:	00b72623		sw	a1,12(a4)
     938:	01070713		addi	a4,a4,16
     93c:	fed766e3		bltu	a4,a3,0x928
     940:	00061463		bnez	a2,0x948
     944:	00008067		ret
     948:	40c306b3		sub	a3,t1,a2
     94c:	00269693		slli	a3,a3,0x2
     950:	00000297		auipc	t0,0x0
     954:	005686b3		add	a3,a3,t0
     958:	00c68067		jalr	zero,a3,12
     95c:	00b70723		sb	a1,14(a4)
     960:	00b706a3		sb	a1,13(a4)
     964:	00b70623		sb	a1,12(a4)
     968:	00b705a3		sb	a1,11(a4)
     96c:	00b70523		sb	a1,10(a4)
     970:	00b704a3		sb	a1,9(a4)
     974:	00b70423		sb	a1,8(a4)
     978:	00b703a3		sb	a1,7(a4)
     97c:	00b70323		sb	a1,6(a4)
     980:	00b702a3		sb	a1,5(a4)
     984:	00b70223		sb	a1,4(a4)
     988:	00b701a3		sb	a1,3(a4)
     98c:	00b70123		sb	a1,2(a4)
     990:	00b700a3		sb	a1,1(a4)
     994:	00b70023		sb	a1,0(a4)
     998:	00008067		ret
     99c:	0ff5f593		andi	a1,a1,255
     9a0:	00859693		slli	a3,a1,0x8
     9a4:	00d5e5b3		or	a1,a1,a3
     9a8:	01059693		slli	a3,a1,0x10
     9ac:	00d5e5b3		or	a1,a1,a3
     9b0:	f6dff06f		j	0x91C
     9b4:	00279693		slli	a3,a5,0x2
     9b8:	00000297		auipc	t0,0x0
     9bc:	005686b3		add	a3,a3,t0
     9c0:	00008293		mv	t0,ra
     9c4:	fa0680e7		jalr	ra,a3,-96
     9c8:	00028093		mv	ra,t0
     9cc:	ff078793		addi	a5,a5,-16
     9d0:	40f70733		sub	a4,a4,a5
     9d4:	00f60633		add	a2,a2,a5
     9d8:	f6c378e3		bgeu	t1,a2,0x948
     9dc:	f3dff06f		j	0x918
     9e0:	00001717		auipc	a4,0x1
     9e4:	a5072703		lw	a4,-1456(a4)
     9e8:	14872783		lw	a5,328(a4)
     9ec:	04078c63		beqz	a5,0xa44
     9f0:	0047a703		lw	a4,4(a5)
     9f4:	01f00813		li	a6,31
     9f8:	06e84e63		blt	a6,a4,0xa74
     9fc:	00271813		slli	a6,a4,0x2
     a00:	02050663		beqz	a0,0xa2c
     a04:	01078333		add	t1,a5,a6
     a08:	08c32423		sw	a2,136(t1)
     a0c:	1887a883		lw	a7,392(a5)
     a10:	00100613		li	a2,1
     a14:	00e61633		sll	a2,a2,a4
     a18:	00c8e8b3		or	a7,a7,a2
     a1c:	1917a423		sw	a7,392(a5)
     a20:	10d32423		sw	a3,264(t1)
     a24:	00200693		li	a3,2
     a28:	02d50463		beq	a0,a3,0xa50
     a2c:	00170713		addi	a4,a4,1
     a30:	00e7a223		sw	a4,4(a5)
     a34:	010787b3		add	a5,a5,a6
     a38:	00b7a423		sw	a1,8(a5)
     a3c:	00000513		li	a0,0
     a40:	00008067		ret
     a44:	14c70793		addi	a5,a4,332
     a48:	14f72423		sw	a5,328(a4)
     a4c:	fa5ff06f		j	0x9F0
     a50:	18c7a683		lw	a3,396(a5)
     a54:	00170713		addi	a4,a4,1
     a58:	00e7a223		sw	a4,4(a5)
     a5c:	00c6e6b3		or	a3,a3,a2
     a60:	18d7a623		sw	a3,396(a5)
     a64:	010787b3		add	a5,a5,a6
     a68:	00b7a423		sw	a1,8(a5)
     a6c:	00000513		li	a0,0
     a70:	00008067		ret
     a74:	fff00513		li	a0,-1
     a78:	00008067		ret
     a7c:	fd010113		addi	sp,sp,-48
     a80:	01412c23		sw	s4,24(sp)
     a84:	00001a17		auipc	s4,0x1
     a88:	9aca2a03		lw	s4,-1620(s4)
     a8c:	03212023		sw	s2,32(sp)
     a90:	148a2903		lw	s2,328(s4)
     a94:	02112623		sw	ra,44(sp)
     a98:	02812423		sw	s0,40(sp)
     a9c:	02912223		sw	s1,36(sp)
     aa0:	01312e23		sw	s3,28(sp)
     aa4:	01512a23		sw	s5,20(sp)
     aa8:	01612823		sw	s6,16(sp)
     aac:	01712623		sw	s7,12(sp)
     ab0:	01812423		sw	s8,8(sp)
     ab4:	04090063		beqz	s2,0xaf4
     ab8:	00050b13		mv	s6,a0
     abc:	00058b93		mv	s7,a1
     ac0:	00100a93		li	s5,1
     ac4:	fff00993		li	s3,-1
     ac8:	00492483		lw	s1,4(s2)
     acc:	fff48413		addi	s0,s1,-1
     ad0:	02044263		bltz	s0,0xaf4
     ad4:	00249493		slli	s1,s1,0x2
     ad8:	009904b3		add	s1,s2,s1
     adc:	040b8463		beqz	s7,0xb24
     ae0:	1044a783		lw	a5,260(s1)
     ae4:	05778063		beq	a5,s7,0xb24
     ae8:	fff40413		addi	s0,s0,-1
     aec:	ffc48493		addi	s1,s1,-4
     af0:	ff3416e3		bne	s0,s3,0xadc
     af4:	02c12083		lw	ra,44(sp)
     af8:	02812403		lw	s0,40(sp)
     afc:	02412483		lw	s1,36(sp)
     b00:	02012903		lw	s2,32(sp)
     b04:	01c12983		lw	s3,28(sp)
     b08:	01812a03		lw	s4,24(sp)
     b0c:	01412a83		lw	s5,20(sp)
     b10:	01012b03		lw	s6,16(sp)
     b14:	00c12b83		lw	s7,12(sp)
     b18:	00812c03		lw	s8,8(sp)
     b1c:	03010113		addi	sp,sp,48
     b20:	00008067		ret
     b24:	00492783		lw	a5,4(s2)
     b28:	0044a683		lw	a3,4(s1)
     b2c:	fff78793		addi	a5,a5,-1
     b30:	04878e63		beq	a5,s0,0xb8c
     b34:	0004a223		sw	zero,4(s1)
     b38:	fa0688e3		beqz	a3,0xae8
     b3c:	18892783		lw	a5,392(s2)
     b40:	008a9733		sll	a4,s5,s0
     b44:	00492c03		lw	s8,4(s2)
     b48:	00f777b3		and	a5,a4,a5
     b4c:	02079263		bnez	a5,0xb70
     b50:	000680e7		jalr	a3
     b54:	00492703		lw	a4,4(s2)
     b58:	148a2783		lw	a5,328(s4)
     b5c:	01871463		bne	a4,s8,0xb64
     b60:	f92784e3		beq	a5,s2,0xae8
     b64:	f80788e3		beqz	a5,0xaf4
     b68:	00078913		mv	s2,a5
     b6c:	f5dff06f		j	0xAC8
     b70:	18c92783		lw	a5,396(s2)
     b74:	0844a583		lw	a1,132(s1)
     b78:	00f77733		and	a4,a4,a5
     b7c:	00071c63		bnez	a4,0xb94
     b80:	000b0513		mv	a0,s6
     b84:	000680e7		jalr	a3
     b88:	fcdff06f		j	0xB54
     b8c:	00892223		sw	s0,4(s2)
     b90:	fa9ff06f		j	0xB38
     b94:	00058513		mv	a0,a1
     b98:	000680e7		jalr	a3
     b9c:	fb9ff06f		j	0xB54
     ba0:	00000000		Unknown instruction:        0 
     ba4:	00000000		Unknown instruction:        0 
     ba8:	00000000		Unknown instruction:        0 
     bac:	00000000		Unknown instruction:        0 
     bb0:	00000000		Unknown instruction:        0 
     bb4:	00000000		Unknown instruction:        0 
     bb8:	00000000		Unknown instruction:        0 
     bbc:	00000000		Unknown instruction:        0 
     bc0:	00000000		Unknown instruction:        0 
     bc4:	00000000		Unknown instruction:        0 
     bc8:	00000000		Unknown instruction:        0 
     bcc:	00000000		Unknown instruction:        0 
     bd0:	00000000		Unknown instruction:        0 
     bd4:	00000000		Unknown instruction:        0 
     bd8:	00000000		Unknown instruction:        0 
     bdc:	00000000		Unknown instruction:        0 
     be0:	00000000		Unknown instruction:        0 
     be4:	00000000		Unknown instruction:        0 
     be8:	00000000		Unknown instruction:        0 
     bec:	00000000		Unknown instruction:        0 
     bf0:	00000000		Unknown instruction:        0 
     bf4:	00000000		Unknown instruction:        0 
     bf8:	00000000		Unknown instruction:        0 
     bfc:	00000000		Unknown instruction:        0 
     c00:	00000000		Unknown instruction:        0 
     c04:	00000000		Unknown instruction:        0 
     c08:	00000000		Unknown instruction:        0 
     c0c:	00000000		Unknown instruction:        0 
     c10:	00000000		Unknown instruction:        0 
     c14:	00000000		Unknown instruction:        0 
     c18:	00000000		Unknown instruction:        0 
     c1c:	00000000		Unknown instruction:        0 
     c20:	00000000		Unknown instruction:        0 
     c24:	00000000		Unknown instruction:        0 
     c28:	00000000		Unknown instruction:        0 
     c2c:	00000000		Unknown instruction:        0 
     c30:	00000000		Unknown instruction:        0 
     c34:	00000000		Unknown instruction:        0 
     c38:	00000000		Unknown instruction:        0 
     c3c:	00000000		Unknown instruction:        0 
     c40:	00000000		Unknown instruction:        0 
     c44:	00000000		Unknown instruction:        0 
     c48:	00000000		Unknown instruction:        0 
     c4c:	00000000		Unknown instruction:        0 
     c50:	00000000		Unknown instruction:        0 
     c54:	00000000		Unknown instruction:        0 
     c58:	00000000		Unknown instruction:        0 
     c5c:	00000000		Unknown instruction:        0 
     c60:	00000000		Unknown instruction:        0 
     c64:	00000000		Unknown instruction:        0 
     c68:	00000000		Unknown instruction:        0 
     c6c:	00000000		Unknown instruction:        0 
     c70:	00000000		Unknown instruction:        0 
     c74:	00000000		Unknown instruction:        0 
     c78:	00000000		Unknown instruction:        0 
     c7c:	00000000		Unknown instruction:        0 
     c80:	00000000		Unknown instruction:        0 
     c84:	00000000		Unknown instruction:        0 
     c88:	00000000		Unknown instruction:        0 
     c8c:	00000000		Unknown instruction:        0 
     c90:	00000000		Unknown instruction:        0 
     c94:	00000000		Unknown instruction:        0 
     c98:	00000000		Unknown instruction:        0 
     c9c:	00000000		Unknown instruction:        0 
     ca0:	00000000		Unknown instruction:        0 
     ca4:	00000000		Unknown instruction:        0 
     ca8:	00000000		Unknown instruction:        0 
     cac:	00000000		Unknown instruction:        0 
     cb0:	00000000		Unknown instruction:        0 
     cb4:	00000000		Unknown instruction:        0 
     cb8:	00000000		Unknown instruction:        0 
     cbc:	00000000		Unknown instruction:        0 
     cc0:	00000000		Unknown instruction:        0 
     cc4:	00000000		Unknown instruction:        0 
     cc8:	00000000		Unknown instruction:        0 
     ccc:	00000000		Unknown instruction:        0 
     cd0:	00000000		Unknown instruction:        0 
     cd4:	00000000		Unknown instruction:        0 
     cd8:	00000000		Unknown instruction:        0 
     cdc:	00000000		Unknown instruction:        0 
     ce0:	00000000		Unknown instruction:        0 
     ce4:	00000000		Unknown instruction:        0 
     ce8:	00000000		Unknown instruction:        0 
     cec:	00000000		Unknown instruction:        0 
     cf0:	00000000		Unknown instruction:        0 
     cf4:	00000000		Unknown instruction:        0 
     cf8:	00000000		Unknown instruction:        0 
     cfc:	00000000		Unknown instruction:        0 
     d00:	00000000		Unknown instruction:        0 
     d04:	00000000		Unknown instruction:        0 
     d08:	00000000		Unknown instruction:        0 
     d0c:	00000000		Unknown instruction:        0 
     d10:	00000000		Unknown instruction:        0 
     d14:	00000000		Unknown instruction:        0 
     d18:	00000000		Unknown instruction:        0 
     d1c:	00000000		Unknown instruction:        0 
     d20:	00000000		Unknown instruction:        0 
     d24:	00000000		Unknown instruction:        0 
     d28:	00000000		Unknown instruction:        0 
     d2c:	00000000		Unknown instruction:        0 
     d30:	00000000		Unknown instruction:        0 
     d34:	00000000		Unknown instruction:        0 
     d38:	00000000		Unknown instruction:        0 
     d3c:	00000000		Unknown instruction:        0 
     d40:	00000000		Unknown instruction:        0 
     d44:	00000000		Unknown instruction:        0 
     d48:	00000000		Unknown instruction:        0 
     d4c:	00000000		Unknown instruction:        0 
     d50:	00000000		Unknown instruction:        0 
     d54:	00000000		Unknown instruction:        0 
     d58:	00000000		Unknown instruction:        0 
     d5c:	00000000		Unknown instruction:        0 
     d60:	00000000		Unknown instruction:        0 
     d64:	00000000		Unknown instruction:        0 
     d68:	00000000		Unknown instruction:        0 
     d6c:	00000000		Unknown instruction:        0 
     d70:	00000000		Unknown instruction:        0 
     d74:	00000000		Unknown instruction:        0 
     d78:	00000000		Unknown instruction:        0 
     d7c:	00000000		Unknown instruction:        0 
     d80:	00000000		Unknown instruction:        0 
     d84:	00000000		Unknown instruction:        0 
     d88:	00000000		Unknown instruction:        0 
     d8c:	00000000		Unknown instruction:        0 
     d90:	00000000		Unknown instruction:        0 
     d94:	00000000		Unknown instruction:        0 
     d98:	00000000		Unknown instruction:        0 
     d9c:	00000000		Unknown instruction:        0 
     da0:	00000000		Unknown instruction:        0 
     da4:	00000000		Unknown instruction:        0 
     da8:	00000000		Unknown instruction:        0 
     dac:	00000000		Unknown instruction:        0 
     db0:	00000000		Unknown instruction:        0 
     db4:	00000000		Unknown instruction:        0 
     db8:	00000000		Unknown instruction:        0 
     dbc:	00000000		Unknown instruction:        0 
     dc0:	00000000		Unknown instruction:        0 
     dc4:	00000000		Unknown instruction:        0 
     dc8:	00000000		Unknown instruction:        0 
     dcc:	00000000		Unknown instruction:        0 
     dd0:	00000000		Unknown instruction:        0 
     dd4:	00000000		Unknown instruction:        0 
     dd8:	00000000		Unknown instruction:        0 
     ddc:	00000000		Unknown instruction:        0 
     de0:	00000000		Unknown instruction:        0 
     de4:	00000000		Unknown instruction:        0 
     de8:	00000000		Unknown instruction:        0 
     dec:	00000000		Unknown instruction:        0 
     df0:	00000000		Unknown instruction:        0 
     df4:	00000000		Unknown instruction:        0 
     df8:	00000000		Unknown instruction:        0 
     dfc:	00000000		Unknown instruction:        0 
     e00:	00000000		Unknown instruction:        0 
     e04:	00000000		Unknown instruction:        0 
     e08:	00000000		Unknown instruction:        0 
     e0c:	00000000		Unknown instruction:        0 
     e10:	00000000		Unknown instruction:        0 
     e14:	00000000		Unknown instruction:        0 
     e18:	00000000		Unknown instruction:        0 
     e1c:	00000000		Unknown instruction:        0 
     e20:	00000000		Unknown instruction:        0 
     e24:	00000000		Unknown instruction:        0 
     e28:	00000000		Unknown instruction:        0 
     e2c:	00000000		Unknown instruction:        0 
     e30:	00000000		Unknown instruction:        0 
     e34:	00000000		Unknown instruction:        0 
     e38:	00000000		Unknown instruction:        0 
     e3c:	00000000		Unknown instruction:        0 
     e40:	00000000		Unknown instruction:        0 
     e44:	00000000		Unknown instruction:        0 
     e48:	00000000		Unknown instruction:        0 
     e4c:	00000000		Unknown instruction:        0 
     e50:	00000000		Unknown instruction:        0 
     e54:	00000000		Unknown instruction:        0 
     e58:	00000000		Unknown instruction:        0 
     e5c:	00000000		Unknown instruction:        0 
     e60:	00000000		Unknown instruction:        0 
     e64:	00000000		Unknown instruction:        0 
     e68:	00000000		Unknown instruction:        0 
     e6c:	00000000		Unknown instruction:        0 
     e70:	00000000		Unknown instruction:        0 
     e74:	00000000		Unknown instruction:        0 
     e78:	00000000		Unknown instruction:        0 
     e7c:	00000000		Unknown instruction:        0 
     e80:	00000000		Unknown instruction:        0 
     e84:	00000000		Unknown instruction:        0 
     e88:	00000000		Unknown instruction:        0 
     e8c:	00000000		Unknown instruction:        0 
     e90:	00000000		Unknown instruction:        0 
     e94:	00000000		Unknown instruction:        0 
     e98:	00000000		Unknown instruction:        0 
     e9c:	00000000		Unknown instruction:        0 
     ea0:	00000000		Unknown instruction:        0 
     ea4:	00000000		Unknown instruction:        0 
     ea8:	00000000		Unknown instruction:        0 
     eac:	00000000		Unknown instruction:        0 
     eb0:	00000000		Unknown instruction:        0 
     eb4:	00000000		Unknown instruction:        0 
     eb8:	00000000		Unknown instruction:        0 
     ebc:	00000000		Unknown instruction:        0 
     ec0:	00000000		Unknown instruction:        0 
     ec4:	00000000		Unknown instruction:        0 
     ec8:	00000000		Unknown instruction:        0 
     ecc:	00000000		Unknown instruction:        0 
     ed0:	00000000		Unknown instruction:        0 
     ed4:	00000000		Unknown instruction:        0 
     ed8:	00000000		Unknown instruction:        0 
     edc:	00000000		Unknown instruction:        0 
     ee0:	00000000		Unknown instruction:        0 
     ee4:	00000000		Unknown instruction:        0 
     ee8:	00000000		Unknown instruction:        0 
     eec:	00000000		Unknown instruction:        0 
     ef0:	00000000		Unknown instruction:        0 
     ef4:	00000000		Unknown instruction:        0 
     ef8:	00000000		Unknown instruction:        0 
     efc:	00000000		Unknown instruction:        0 
     f00:	00000000		Unknown instruction:        0 
     f04:	00000000		Unknown instruction:        0 
     f08:	00000000		Unknown instruction:        0 
     f0c:	00000000		Unknown instruction:        0 
     f10:	00000000		Unknown instruction:        0 
     f14:	00000000		Unknown instruction:        0 
     f18:	00000000		Unknown instruction:        0 
     f1c:	00000000		Unknown instruction:        0 
     f20:	00000000		Unknown instruction:        0 
     f24:	00000000		Unknown instruction:        0 
     f28:	00000000		Unknown instruction:        0 
     f2c:	00000000		Unknown instruction:        0 
     f30:	00000000		Unknown instruction:        0 
     f34:	00000000		Unknown instruction:        0 
     f38:	00000000		Unknown instruction:        0 
     f3c:	00000000		Unknown instruction:        0 
     f40:	00000000		Unknown instruction:        0 
     f44:	00000000		Unknown instruction:        0 
     f48:	00000000		Unknown instruction:        0 
     f4c:	00000000		Unknown instruction:        0 
     f50:	00000000		Unknown instruction:        0 
     f54:	00000000		Unknown instruction:        0 
     f58:	00000000		Unknown instruction:        0 
     f5c:	00000000		Unknown instruction:        0 
     f60:	00000000		Unknown instruction:        0 
     f64:	00000000		Unknown instruction:        0 
     f68:	00000000		Unknown instruction:        0 
     f6c:	00000000		Unknown instruction:        0 
     f70:	00000000		Unknown instruction:        0 
     f74:	00000000		Unknown instruction:        0 
     f78:	00000000		Unknown instruction:        0 
     f7c:	00000000		Unknown instruction:        0 
     f80:	00000000		Unknown instruction:        0 
     f84:	00000000		Unknown instruction:        0 
     f88:	00000000		Unknown instruction:        0 
     f8c:	00000000		Unknown instruction:        0 
     f90:	00000000		Unknown instruction:        0 
     f94:	00000000		Unknown instruction:        0 
     f98:	00000000		Unknown instruction:        0 
     f9c:	00000000		Unknown instruction:        0 
     fa0:	00000000		Unknown instruction:        0 
     fa4:	00000000		Unknown instruction:        0 
     fa8:	00000000		Unknown instruction:        0 
     fac:	00000000		Unknown instruction:        0 
     fb0:	00000000		Unknown instruction:        0 
     fb4:	00000000		Unknown instruction:        0 
     fb8:	00000000		Unknown instruction:        0 
     fbc:	00000000		Unknown instruction:        0 
     fc0:	00000000		Unknown instruction:        0 
     fc4:	00000000		Unknown instruction:        0 
     fc8:	00000000		Unknown instruction:        0 
     fcc:	00000000		Unknown instruction:        0 
     fd0:	00000000		Unknown instruction:        0 
     fd4:	00000000		Unknown instruction:        0 
     fd8:	00000000		Unknown instruction:        0 
     fdc:	00000000		Unknown instruction:        0 
     fe0:	00000000		Unknown instruction:        0 
     fe4:	00000000		Unknown instruction:        0 
     fe8:	00000000		Unknown instruction:        0 
     fec:	00000000		Unknown instruction:        0 
     ff0:	00000000		Unknown instruction:        0 
     ff4:	00000000		Unknown instruction:        0 
     ff8:	00000000		Unknown instruction:        0 
     ffc:	00000000		Unknown instruction:        0 
    1000:	800000b8		Unknown instruction: 800000B8 
    1004:	00000000		Unknown instruction:        0 
    1008:	00000000		Unknown instruction:        0 
    100c:	800012f4		Unknown instruction: 800012F4 
    1010:	8000135c		Unknown instruction: 8000135C 
    1014:	800013c4		Unknown instruction: 800013C4 
    1018:	00000000		Unknown instruction:        0 
    101c:	00000000		Unknown instruction:        0 
    1020:	00000000		Unknown instruction:        0 
    1024:	00000000		Unknown instruction:        0 
    1028:	00000000		Unknown instruction:        0 
    102c:	00000000		Unknown instruction:        0 
    1030:	00000000		Unknown instruction:        0 
    1034:	00000000		Unknown instruction:        0 
    1038:	00000000		Unknown instruction:        0 
    103c:	00000000		Unknown instruction:        0 
    1040:	00000000		Unknown instruction:        0 
    1044:	00000000		Unknown instruction:        0 
    1048:	00000000		Unknown instruction:        0 
    104c:	00000000		Unknown instruction:        0 
    1050:	00000000		Unknown instruction:        0 
    1054:	00000000		Unknown instruction:        0 
    1058:	00000000		Unknown instruction:        0 
    105c:	00000000		Unknown instruction:        0 
    1060:	00000000		Unknown instruction:        0 
    1064:	00000000		Unknown instruction:        0 
    1068:	00000000		Unknown instruction:        0 
    106c:	00000000		Unknown instruction:        0 
    1070:	00000000		Unknown instruction:        0 
    1074:	00000000		Unknown instruction:        0 
    1078:	00000000		Unknown instruction:        0 
    107c:	00000000		Unknown instruction:        0 
    1080:	00000000		Unknown instruction:        0 
    1084:	00000000		Unknown instruction:        0 
    1088:	00000000		Unknown instruction:        0 
    108c:	00000000		Unknown instruction:        0 
    1090:	00000000		Unknown instruction:        0 
    1094:	00000000		Unknown instruction:        0 
    1098:	00000000		Unknown instruction:        0 
    109c:	00000000		Unknown instruction:        0 
    10a0:	00000000		Unknown instruction:        0 
    10a4:	00000000		Unknown instruction:        0 
    10a8:	00000000		Unknown instruction:        0 
    10ac:	00000000		Unknown instruction:        0 
    10b0:	00000001		Unknown instruction:        1 
    10b4:	00000000		Unknown instruction:        0 
    10b8:	abcd330e		Unknown instruction: ABCD330E 
    10bc:	e66d1234		Unknown instruction: E66D1234 
    10c0:	0005deec		Unknown instruction:    5DEEC 
    10c4:	0000000b		Unknown instruction:        B 
    10c8:	00000000		Unknown instruction:        0 
    10cc:	00000000		Unknown instruction:        0 
    10d0:	00000000		Unknown instruction:        0 
    10d4:	00000000		Unknown instruction:        0 
    10d8:	00000000		Unknown instruction:        0 
    10dc:	00000000		Unknown instruction:        0 
    10e0:	00000000		Unknown instruction:        0 
    10e4:	00000000		Unknown instruction:        0 
    10e8:	00000000		Unknown instruction:        0 
    10ec:	00000000		Unknown instruction:        0 
    10f0:	00000000		Unknown instruction:        0 
    10f4:	00000000		Unknown instruction:        0 
    10f8:	00000000		Unknown instruction:        0 
    10fc:	00000000		Unknown instruction:        0 
    1100:	00000000		Unknown instruction:        0 
    1104:	00000000		Unknown instruction:        0 
    1108:	00000000		Unknown instruction:        0 
    110c:	00000000		Unknown instruction:        0 
    1110:	00000000		Unknown instruction:        0 
    1114:	00000000		Unknown instruction:        0 
    1118:	00000000		Unknown instruction:        0 
    111c:	00000000		Unknown instruction:        0 
    1120:	00000000		Unknown instruction:        0 
    1124:	00000000		Unknown instruction:        0 
    1128:	00000000		Unknown instruction:        0 
    112c:	00000000		Unknown instruction:        0 
    1130:	00000000		Unknown instruction:        0 
    1134:	00000000		Unknown instruction:        0 
    1138:	00000000		Unknown instruction:        0 
    113c:	00000000		Unknown instruction:        0 
    1140:	00000000		Unknown instruction:        0 
    1144:	00000000		Unknown instruction:        0 
    1148:	00000000		Unknown instruction:        0 
    114c:	00000000		Unknown instruction:        0 
    1150:	00000000		Unknown instruction:        0 
    1154:	00000000		Unknown instruction:        0 
    1158:	00000000		Unknown instruction:        0 
    115c:	00000000		Unknown instruction:        0 
    1160:	00000000		Unknown instruction:        0 
    1164:	00000000		Unknown instruction:        0 
    1168:	00000000		Unknown instruction:        0 
    116c:	00000000		Unknown instruction:        0 
    1170:	00000000		Unknown instruction:        0 
    1174:	00000000		Unknown instruction:        0 
    1178:	00000000		Unknown instruction:        0 
    117c:	00000000		Unknown instruction:        0 
    1180:	00000000		Unknown instruction:        0 
    1184:	00000000		Unknown instruction:        0 
    1188:	00000000		Unknown instruction:        0 
    118c:	00000000		Unknown instruction:        0 
    1190:	00000000		Unknown instruction:        0 
    1194:	00000000		Unknown instruction:        0 
    1198:	00000000		Unknown instruction:        0 
    119c:	00000000		Unknown instruction:        0 
    11a0:	00000000		Unknown instruction:        0 
    11a4:	00000000		Unknown instruction:        0 
    11a8:	00000000		Unknown instruction:        0 
    11ac:	00000000		Unknown instruction:        0 
    11b0:	00000000		Unknown instruction:        0 
    11b4:	00000000		Unknown instruction:        0 
    11b8:	00000000		Unknown instruction:        0 
    11bc:	00000000		Unknown instruction:        0 
    11c0:	00000000		Unknown instruction:        0 
    11c4:	00000000		Unknown instruction:        0 
    11c8:	00000000		Unknown instruction:        0 
    11cc:	00000000		Unknown instruction:        0 
    11d0:	00000000		Unknown instruction:        0 
    11d4:	00000000		Unknown instruction:        0 
    11d8:	00000000		Unknown instruction:        0 
    11dc:	00000000		Unknown instruction:        0 
    11e0:	00000000		Unknown instruction:        0 
    11e4:	00000000		Unknown instruction:        0 
    11e8:	00000000		Unknown instruction:        0 
    11ec:	00000000		Unknown instruction:        0 
    11f0:	00000000		Unknown instruction:        0 
    11f4:	00000000		Unknown instruction:        0 
    11f8:	00000000		Unknown instruction:        0 
    11fc:	00000000		Unknown instruction:        0 
    1200:	00000000		Unknown instruction:        0 
    1204:	00000000		Unknown instruction:        0 
    1208:	00000000		Unknown instruction:        0 
    120c:	00000000		Unknown instruction:        0 
    1210:	00000000		Unknown instruction:        0 
    1214:	00000000		Unknown instruction:        0 
    1218:	00000000		Unknown instruction:        0 
    121c:	00000000		Unknown instruction:        0 
    1220:	00000000		Unknown instruction:        0 
    1224:	00000000		Unknown instruction:        0 
    1228:	00000000		Unknown instruction:        0 
    122c:	00000000		Unknown instruction:        0 
    1230:	00000000		Unknown instruction:        0 
    1234:	00000000		Unknown instruction:        0 
    1238:	00000000		Unknown instruction:        0 
    123c:	00000000		Unknown instruction:        0 
    1240:	00000000		Unknown instruction:        0 
    1244:	00000000		Unknown instruction:        0 
    1248:	00000000		Unknown instruction:        0 
    124c:	00000000		Unknown instruction:        0 
    1250:	00000000		Unknown instruction:        0 
    1254:	00000000		Unknown instruction:        0 
    1258:	00000000		Unknown instruction:        0 
    125c:	00000000		Unknown instruction:        0 
    1260:	00000000		Unknown instruction:        0 
    1264:	00000000		Unknown instruction:        0 
    1268:	00000000		Unknown instruction:        0 
    126c:	00000000		Unknown instruction:        0 
    1270:	00000000		Unknown instruction:        0 
    1274:	00000000		Unknown instruction:        0 
    1278:	00000000		Unknown instruction:        0 
    127c:	00000000		Unknown instruction:        0 
    1280:	00000000		Unknown instruction:        0 
    1284:	00000000		Unknown instruction:        0 
    1288:	00000000		Unknown instruction:        0 
    128c:	00000000		Unknown instruction:        0 
    1290:	00000000		Unknown instruction:        0 
    1294:	00000000		Unknown instruction:        0 
    1298:	00000000		Unknown instruction:        0 
    129c:	00000000		Unknown instruction:        0 
    12a0:	00000000		Unknown instruction:        0 
    12a4:	00000000		Unknown instruction:        0 
    12a8:	00000000		Unknown instruction:        0 
    12ac:	00000000		Unknown instruction:        0 
    12b0:	00000000		Unknown instruction:        0 
    12b4:	00000000		Unknown instruction:        0 
    12b8:	00000000		Unknown instruction:        0 
    12bc:	00000000		Unknown instruction:        0 
    12c0:	00000000		Unknown instruction:        0 
    12c4:	00000000		Unknown instruction:        0 
    12c8:	00000000		Unknown instruction:        0 
    12cc:	00000000		Unknown instruction:        0 
    12d0:	00000000		Unknown instruction:        0 
    12d4:	00000000		Unknown instruction:        0 
    12d8:	00000000		Unknown instruction:        0 
    12dc:	00000000		Unknown instruction:        0 
    12e0:	00000000		Unknown instruction:        0 
    12e4:	00000000		Unknown instruction:        0 
    12e8:	00000000		Unknown instruction:        0 
    12ec:	00000000		Unknown instruction:        0 
    12f0:	00000000		Unknown instruction:        0 
    12f4:	00000000		Unknown instruction:        0 
    12f8:	00000000		Unknown instruction:        0 
    12fc:	00000000		Unknown instruction:        0 
    1300:	00000000		Unknown instruction:        0 
    1304:	00000000		Unknown instruction:        0 
    1308:	00000000		Unknown instruction:        0 
    130c:	00000000		Unknown instruction:        0 
    1310:	00000000		Unknown instruction:        0 
    1314:	00000000		Unknown instruction:        0 
    1318:	00000000		Unknown instruction:        0 
    131c:	00000000		Unknown instruction:        0 
    1320:	00000000		Unknown instruction:        0 
    1324:	00000000		Unknown instruction:        0 
    1328:	00000000		Unknown instruction:        0 
    132c:	00000000		Unknown instruction:        0 
    1330:	00000000		Unknown instruction:        0 
    1334:	00000000		Unknown instruction:        0 
    1338:	00000000		Unknown instruction:        0 
    133c:	00000000		Unknown instruction:        0 
    1340:	00000000		Unknown instruction:        0 
    1344:	00000000		Unknown instruction:        0 
    1348:	00000000		Unknown instruction:        0 
    134c:	00000000		Unknown instruction:        0 
    1350:	00000000		Unknown instruction:        0 
    1354:	00000000		Unknown instruction:        0 
    1358:	00000000		Unknown instruction:        0 
    135c:	00000000		Unknown instruction:        0 
    1360:	00000000		Unknown instruction:        0 
    1364:	00000000		Unknown instruction:        0 
    1368:	00000000		Unknown instruction:        0 
    136c:	00000000		Unknown instruction:        0 
    1370:	00000000		Unknown instruction:        0 
    1374:	00000000		Unknown instruction:        0 
    1378:	00000000		Unknown instruction:        0 
    137c:	00000000		Unknown instruction:        0 
    1380:	00000000		Unknown instruction:        0 
    1384:	00000000		Unknown instruction:        0 
    1388:	00000000		Unknown instruction:        0 
    138c:	00000000		Unknown instruction:        0 
    1390:	00000000		Unknown instruction:        0 
    1394:	00000000		Unknown instruction:        0 
    1398:	00000000		Unknown instruction:        0 
    139c:	00000000		Unknown instruction:        0 
    13a0:	00000000		Unknown instruction:        0 
    13a4:	00000000		Unknown instruction:        0 
    13a8:	00000000		Unknown instruction:        0 
    13ac:	00000000		Unknown instruction:        0 
    13b0:	00000000		Unknown instruction:        0 
    13b4:	00000000		Unknown instruction:        0 
    13b8:	00000000		Unknown instruction:        0 
    13bc:	00000000		Unknown instruction:        0 
    13c0:	00000000		Unknown instruction:        0 
    13c4:	00000000		Unknown instruction:        0 
    13c8:	00000000		Unknown instruction:        0 
    13cc:	00000000		Unknown instruction:        0 
    13d0:	00000000		Unknown instruction:        0 
    13d4:	00000000		Unknown instruction:        0 
    13d8:	00000000		Unknown instruction:        0 
    13dc:	00000000		Unknown instruction:        0 
    13e0:	00000000		Unknown instruction:        0 
    13e4:	00000000		Unknown instruction:        0 
    13e8:	00000000		Unknown instruction:        0 
    13ec:	00000000		Unknown instruction:        0 
    13f0:	00000000		Unknown instruction:        0 
    13f4:	00000000		Unknown instruction:        0 
    13f8:	00000000		Unknown instruction:        0 
    13fc:	00000000		Unknown instruction:        0 
    1400:	00000000		Unknown instruction:        0 
    1404:	00000000		Unknown instruction:        0 
    1408:	00000000		Unknown instruction:        0 
    140c:	00000000		Unknown instruction:        0 
    1410:	00000000		Unknown instruction:        0 
    1414:	00000000		Unknown instruction:        0 
    1418:	00000000		Unknown instruction:        0 
    141c:	00000000		Unknown instruction:        0 
    1420:	00000000		Unknown instruction:        0 
    1424:	00000000		Unknown instruction:        0 
    1428:	00000000		Unknown instruction:        0 
    142c:	00000000		Unknown instruction:        0 
    1430:	80001008		Unknown instruction: 80001008 
