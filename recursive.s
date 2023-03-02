								###selection sort###
	.text
	.globl	main
main:	
	la	$s0, array		#s0 = array address
	la	$s4, array		#s3 = array address的頭(output)
input:	
	li	$v0, 5			#input number
	syscall
	beq	$v0, $0, rec_set	#input = = 0,排序
	sw	$v0, 0($s0)		#input存到array
	addi 	$s0, 4			#s0 = s0 + 4
	j	input			#繼續輸入


rec_set:
	la	$s1, array		#s1 = array address的頭
	add	$s3, $s0, $0		#s3 = array 最後的address
	jal	rec

output:
	beq	$s4, $s0, exit		#s4 = = s0 ,結束輸出
	lw	$a0, 0($s4)		#a0 = array[i]
	li	$v0, 1			#輸出數字
	syscall
	la	$a0, space		
	li	$v0, 4			#輸出空格
	syscall
	addi	$s4, 4			#i++
	j	output
exit:	
	la	$a0, enter		#換行
	li	$v0, 4		
	syscall	

	li	$v0, 10			#程式結束
	syscall	


rec:
	bne	$s1, $s0, rec_sel	#s1 = = s0 ,結束遞迴				#void recursiveSelection(&array[] , int i = 0){
	jr	$ra									#	
rec_sel:										#	if (i = = &array[尾]) return;
	addi	$sp, -4									#	
	sw	$ra, 0($sp)		#$ra存到stack					#	int max = findmaxdex (&array[] , i);
	move	$a0, $0			#int max = 0					#
	move	$s2, $s1		#j = = i					#	recursiveSelection(&array[] , i + 1);
	jal	max			#int max = findmaxdex(&array[] , s2 , s0)	#}	
	move	$a0, $v0		#將return回來的maxindex存回 $a0			#
	beq	$s1, $a0, noswap	#if (i ! = max) swap				#
	jal 	swap									#
noswap:	lw	$ra, 0($sp)		#將$ra取出					#
	addi	$sp, 4									#
	addi	$sp, -16		#$ra,$s1,$s0,$a0存到stack			#
	sw	$s1, 0($sp)								#
	sw	$s0, 4($sp)								#
	sw	$a0, 8($sp)								#
	sw	$ra, 12($sp)								#
	addi	$s1, 4									#
	jal	rec									#
	lw	$ra, 12($sp)
	lw	$a0, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addi	$sp, 16
	jr	$ra


max:
	bne	$s2, $s3, findmaxindex	#s2 = = s3 結束遞迴				#void findmaxdex (&array[] , j){
	addi	$v0, $s2, -4		#if(s2 = = s3) v0 = array最後一個元素的index	#
	jr	$ra									#	if (j = = &array[尾]) return;
findmaxindex:										#
	addi	$sp, -16		#$s2,$s3,$a1,$ra 存到stack			#	int max = findmaxdex (&array[] , j+1);
	sw	$s2, 0($sp)								#
	sw	$s3, 4($sp)								#	return (array[max] < array[j]) ? j : max;
	sw	$a1, 8($sp)								#}
	sw	$ra, 12($sp)								#
	addi	$s2, 4									#
	jal	max									#
	lw	$ra, 12($sp)
	lw	$a1, 8($sp)
	lw	$s3, 4($sp)
	lw	$s2, 0($sp)
	addi	$sp, 16
	lw	$t0, 0($v0)		#t0 = array[max]
	lw	$t1, 0($s2)		#t1 = array[j]
	blt	$t1, $t0, no		#if(array[max] < t1 = array[j]) max = j
	move	$v0, $s2
no:	jr	$ra




swap:
	lw	$t1, 0($a0)		#t1 = array[max]
	lw	$t2, 0($s1)		#t2 = array[i]
	sw	$t2, 0($a0)		#array[max] = t2
	sw	$t1, 0($s1)		#array[i] = t1
	jr	$ra			#return




	.data
array:	.space	1024			#int array[256]
enter:	.asciiz	"\n"
space:	.asciiz	" "