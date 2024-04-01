.section .data
sdmid:  .ascii "000111", "\0\0\0"     # 9个字节 
sda:    .long  512      # 状态信息a
sdb:    .long  -1023    # 状态信息b
sdc:    .long  1265     # 状态信息c
sf:     .long  0        # 处理结果f，4个long有16个字节 6
        .ascii "000222","\0\0\0" 
        .long  256809   # 状态信息a
        .long  -1023    # 状态信息b
        .long  2780     # 状态信息c
        .long  0        # 处理结果f 5
        .ascii "000333","\0\0\0" 
        .long  2513     # 状态信息a
        .long  1265     # 状态信息b
        .long  1023     # 状态信息c
        .long  0        # 处理结果f 4
        .ascii "000444","\0\0\0" 
        .long  512      # 状态信息a
        .long  -1023    # 状态信息b
        .long  1265     # 状态信息c
        .long  0        # 处理结果f 3
        .ascii "555555","\0\0\0"
        .long  2513     # 状态信息a
        .long  1265     # 状态信息b
        .long  1023     # 状态信息c
        .long  0        # 处理结果f 2
        .ascii "666666","\0\0\0"
        .long  256800    # 状态信息a
        .long  -2000     # 状态信息b
        .long  1000      # 状态信息c
        .long  0         # 处理结果f 1
num = 6
midf:   .fill 9, 1, 0 
        .long 0, 0, 0, 0
        .fill 9, 1, 0
        .long 0, 0, 0, 0
        .fill 9, 1, 0
        .long 0, 0, 0, 0
highf:  .fill 9, 1, 0 
        .long 0, 0, 0, 0
        .fill 9, 1, 0
        .long 0, 0, 0, 0
        .fill 9, 1, 0
        .long 0, 0, 0, 0
lowf:   .fill 9, 1, 0 
        .long 0, 0, 0, 0
        .fill 9, 1, 0
        .long 0, 0, 0, 0
        .fill 9, 1, 0
        .long 0, 0, 0, 0
len = 25

# how to compile 32-bits assembly code in linux
# as --32 -g -o task3.o task3.s
# ld -m elf_i386 -o task3 task3.o
# gcc -m32 task3.s -no-pie -o task3 !!wrong!!

.section .text
.global _start
_start:
    mov $num, %ecx          # 设置计数器，用于循环
    lea sdmid, %esi         # esi = &sdmid, 将状态信息的起始地址放入esi中
    lea midf, %edi          # 设置LOWF为默认的复制目标地址

proc_loop:
    # 调用calculate函数计算f
    push %esi               # 保存esi
    call calculate
    pop %esi                # 恢复esi
    mov %eax, %edx          # 保存calculate返回的状态

    # 根据f值选择不同的复制目的地
    cmp $100, %edx
    je .equal
    jg .greater
    jl .lower

.greater:
    lea highf, %edi
    jmp .copy               # 进行数据复制

.equal:
    lea midf, %edi
    jmp .copy

.lower:
    lea lowf, %edi
    jmp .copy

.copy:
    push %esi               # 保存源地址寄存器
    push %edi               # 保存目标地址寄存器，是proc_loop中求出的目标地址
    call copy_data          # 调用copy_data函数进行数据复制
    pop %edi                # copy_data中移动了edi和esi，所以需要恢复目标地址寄存器
    pop %esi                # 恢复源地址寄存器
    test %ecx, %ecx
    jz proc_end
    add $len, %esi
    loop proc_loop

proc_end:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
    
.type calculate @function
calculate:
    push %ebp
    mov %esp, %ebp

    movl 9(%esi), %eax       # eax = a
    imull $5, %eax, %eax    # eax = 5 * a
    addl 13(%esi), %eax      # eax = 5 * a + b
    subl 17(%esi), %eax      # eax = 5 * a + b - c
    addl $100, %eax         # eax = 5 * a + b - c + 100
    movl $128, %ebx         # ebx = 128
    cltd                    # 用于符号扩展EAX寄存器的值到EDX:EAX（本质上是把32位的EAX寄存器扩展为64位）
    idivl %ebx              # eax = (5 * a + b - c + 100) / 128
    movl %eax, 21(%esi)     # f = (5 * a + b - c + 100) / 128
    
    mov %ebp, %esp
    pop %ebp
    ret

.type copy_data @function
copy_data:
    push %ebp               # 保存ebp
    mov %esp, %ebp          # 设置当前的ebp

    mov 8(%ebp), %edi       # 目标地址
    mov 12(%ebp), %esi      # 源地址

    # 前9个字节的复制
    movl (%esi), %eax       # 读取源地址的4字节数据
    movl %eax, (%edi)       # 将数据写入目标地址的4字节空间
    addl $4, %esi           # 源地址指针移动4字节
    addl $4, %edi           # 目标地址指针移动4字节

    movl (%esi), %eax
    movl %eax, (%edi)
    addl $4, %esi
    addl $4, %edi

    movb (%esi), %al        # 读取源地址的1字节数据
    movb %al, (%edi)        # 将数据写入目标地址的1字节空间
    add $1, %esi
    add $1, %edi

    # 下面是a, b, c, f的复制
    movl (%esi), %eax
    movl %eax, (%edi)
    addl $4, %esi
    addl $4, %edi

    movl (%esi), %eax
    movl %eax, (%edi)
    addl $4, %esi
    addl $4, %edi

    movl (%esi), %eax
    movl %eax, (%edi)
    addl $4, %esi
    addl $4, %edi

    movl (%esi), %eax
    movl %eax, (%edi)
    # 25个字节复制完毕

    # 跳出子程序堆栈框架
    mov %ebp, %esp
    pop %ebp
    ret
