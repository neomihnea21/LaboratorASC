.data
  matrix: .space 2000
  line: .space 4
  column: .space 4
  m: .space 4
  n: .space 4
  k: .space 4
  i: .space 4
  pass: .space 4
  p: .space 4
  formatRead: .asciz "%ld"
.text
.global main
main:
   pushl $m
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   pushl $n
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   pushl $k
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   pushl $p
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   movl $0, i
citire:
   movl i, %ecx
   cmp %ecx, p
   je continuare
   
   pushl $line
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   pushl $column
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   movl line, %eax
   movl $0, %edx
   mull n
   addl column, %eax
   
   lea matrix, %edi
   movl $1, (%edi, %eax, 4)
   
   incl i
   jmp citire
continuare:
  movl $0, i
  pasConway:
    movl i, %ecx
    cmp %ecx, k
    je scriere
    
    movl $0, pass
    movl $0, %ecx
    checkMatrix:
      cmp (%edi, %ecx, 4), $1
      je
      
            
    
    
    
    

   
  
   
   
   
   
   
   
  
  
   
