###selection sort###
	.text
	.globl	main
main:	
	la	$s0, array		#s0 = array address
	la	$s3, array		#s3 = array address的頭(output)
input:	
	li	$v0, 5			#input number
	syscall
	beq	$v0, $0, set		#input = = 0,到迴圈裡
	sw	$v0, 0($s0)		#input存到array
	addi 	$s0, 4			#s0 = s0 + 4
	j	input			#繼續輸入
set:
	la	$s1, array		#s1 = i (s1 = array address的頭)
loop1:
	beq	$s1, $s0, output	#s1 = = s0 ,輸出
	move	$a0, $s1		#max = i
	addi	$s2, $s1, 4		#s2 = j (s2 = i + 1)
	j	loop2
oloop2:	beq	$a0, $s1, noswap	#if (max = = i) don't swap
	jal	swap			#else swap (&array[max] , &array[i])
noswap:	addi	$s1, 4			#i++
	j	loop1
	
loop2:
	beq	$s2, $s0, oloop2	#s2 = = s0 ,結束loop2
	lw	$t1, 0($a0)		#t1 = array[max]
	lw	$t2, 0($s2)		#t2 = array[j]
	blt	$t2, $t1, no		#if (t2 < t1) 不用更新max
	move	$a0, $s2		#else 更新max
no:	addi	$s2, 4			#j++
	j	loop2	

swap:
	lw	$t1, 0($a0)		#t1 = array[max]
	lw	$t2, 0($s1)		#t2 = array[i]
	sw	$t2, 0($a0)		#array[max] = t2
	sw	$t1, 0($s1)		#array[i] = t1
	jr	$ra			#return

output:
	beq	$s3, $s0, exit		#s3 = = s0 ,結束輸出
	lw	$a0, 0($s3)		#a0 = array[i]
	li	$v0, 1			#輸出數字
	syscall
	la	$a0, space		
	li	$v0, 4			#輸出空格
	syscall
	addi	$s3, 4			#i++
	j	output
exit:	
	la	$a0, enter		#換行
	li	$v0, 4		
	syscall	

	li	$v0, 10			#程式結束
	syscall	

	.data
array:	.space	1024			#int array[256]
enter:	.asciiz	"\n"
space:	.asciiz	" "