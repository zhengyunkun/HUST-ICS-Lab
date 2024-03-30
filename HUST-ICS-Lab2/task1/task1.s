.section .data
message: .asciz "Press any key to begin!"
message_length = . - message
buf1: .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 
buf2: .fill 10, 1, 0 
buf3: .fill 10, 1, 0
buf4: .fill 10, 1, 0
.section .text
.global  main
main:

# 输出'Press any key to begin!'的信息
mov $4, %eax
mov $1, %ebx
mov $message, %ecx
mov $message_length, %edx
int $0x80

#接收用户输入
mov $3, %eax
mov $0, %ebx
mov $buf1, %ecx  # 指针指向空间以存储用户输入
mov $1, %edx  # 读取的字节数
int $0x80  # 执行系统调用

#对buf进行操作
mov  $buf1, %esi
mov  $buf2, %edi 
mov  $buf3, %ebx 
mov  $buf4, %edx 
mov  $10, %ecx 
lopa:  mov  (%esi), %al 
mov  %al, (%edi) 
inc  %al
mov  %al, (%ebx)
add  $3,  %al 
mov  %al, (%edx)
inc  %esi
inc  %edi
inc  %ebx
inc  %edx
dec  %ecx
jnz  lopa 
mov  $1, %eax
movl $0, %ebx
int  $0x80