.data
  left: .asciz "left\n"
  right: .asciz "right\n"
  x: .long 21
  y: .long 22
.text
.global main
main:
   mov x, %eax
   mov y, %ebx
   cmp %eax, %ebx
   jl et2
   mov $4, %eax
   mov $1, %ebx
   mov $left, %ecx
   mov $8, %edx
   int $0x80
et2:
   mov $4, %eax
   mov $1, %ebx
   mov $right, %ecx
   mov $8, %edx
   int $0x80
   mov $1, %eax 
   mov $0, %ebx
   int $0x80
