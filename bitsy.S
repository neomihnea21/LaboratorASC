.data
   x: .long 64
   y: .long 3
   temp: .space 4
   res: .space 4
   pass: .asciz "Pass"
   fail: .asciz "Fail"
.text
.global main
 main:
   mov $0, %ecx
   mov x, %eax
   shr $4, %eax
   add %eax, %ecx
   mov %ecx, temp
   mov y, %eax
   shl $4, %eax
   add %eax, %ecx
   mov %ecx, res
   
   mov %eax, 1
   mov %ebx, 0
   int $0x80
            
