.section .data
buf1: .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
buf2: .fill 10, 1, 0
buf3: .fill 10, 1, 0
buf4: .fill 10, 1, 0

.section .text
.global main
main:
  # 初始化索引寄存器和计数器
  mov  $0, %esi         # 索引寄存器esi，从0开始（相对于buf1）
  mov  $0, %edi         # 索引寄存器edi，从0开始（相对于buf2）
  mov  $0, %ebx         # 索引寄存器ebx，从0开始（相对于buf3）
  mov  $0, %edx         # 索引寄存器edx，从0开始（相对于buf4）
  mov  $10, %ecx        # 计数器，用于循环10次
  
lopa:
  # 使用变址寻址（指令中只有偏移量和基地址）进行访问
  movb  buf1(%esi), %al     # 取buf1 + esi（偏移量）指向的值到al
  movb  %al, buf2(%edi)     # 把al的值存到buf2 + edi（偏移量）指向的位置
  inc   %al                 # 增加al的值
  movb  %al, buf3(%ebx)     # 把增加后的al值存到buf3 + ebx（偏移量）指向的位置
  add   $3, %al             # al增加3
  movb  %al, buf4(%edx)     # 把增加3后的al值存到buf4 + edx（偏移量）指向的位置
  
  # 索引寄存器值递增
  inc   %esi
  inc   %edi
  inc   %ebx
  inc   %edx
  
  # 减少循环计数并判断
  dec   %ecx
  jnz   lopa
  
  # 程序退出部分
  mov   $1, %eax
  movl  $0, %ebx
  int   $0x80