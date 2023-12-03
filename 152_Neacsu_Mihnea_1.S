.data
  matrix: .space 2200
  newMatrix: .space 2200
  line: .space 4
  column: .space 4
  m: .space 4
  n: .space 4
  k: .space 4
  i: .space 4
  pos: .space 4
  p: .space 4
  produs: .space 8
  formatRead: .asciz "%ld"
  formatWrite: . asciz "%ld "
  newline: asciz "\n"
  lineIndex: .long 0
  columnIndex: .long 0
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
lea matrix, %edi  
initializare:
  movl m, %eax
  mull n
  # stocam lungimea matricei intr-o variabila, ca nu poti sa compari expresii matematice cu cmp
  movl %eax, produs
  movl i, %ebx
  cmp %eax, %ebx
  je citire
  movl $0, (%edi, %ebx, 4)
  incl i
  jmp initializare
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
   #vom mari indicii de linie si coloana cu 1, ca sa fie bordare
   incl line
   incl column 
   
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
  # i tine cate generatii am facut
  pushl 
  jmp exit
  pasConway:
    movl i, %ecx
    cmp %ecx, k
    je scriere
    # daca am facut k generatii, scrie ce avem
    
    #aprcurgem matricea cu variabilele lineIndex si columnIndex
    movl $1, lineIndex
   C_linii:
     movl lineIndex, %ebx
     cmp lineIndex, m
     jg exit
     movl $1, columnIndex
     #parcurgem linia la care suntem in lineIndex
     C_linieCurenta:
       movl columnIndex, %ebx
       cmp n, %ebx
       jg finalPas
       movl lineIndex, %eax
       xorl %edx, %edx
       mull n
       addl columnIndex, %eax
       #am scos in eax indicele de lucru
       lea matrix, %edi
       movl (%edi, %eax, 4), %ecx
       verificaVecini:
          #ne uitam la vecini sa vedem cum va arata noua matrice
              
       incl columnIndex
       jmp linieCurenta
    finalPas:
    incl i 
    jmp pasConway
# o sa arate neuzual, deoarece matricea e indexata de la 1, ca sa se bordeze    
scriere:
   movl $1, lineIndex
   linii:
     movl lineIndex, %ebx
     cmp lineIndex, m
     jg exit
     movl $1, columnIndex
     #parcurgem linia la care suntem in lineIndex
     linieCurenta:
       movl columnIndex, %ebx
       cmp n, %ebx
       jg finalScriere
       movl lineIndex, %eax
       xorl %edx, %edx
       mull n
       addl columnIndex, %eax
       #am scris in eax indicele unde calculam schimbarea
       
       lea matrix, %edi
       movl (%edi, %eax, 4), %ecx
       generatieUrmatoare:
         cmp %eax, produs
         je pre_schimbare
         verificaVecini:
           #vom intoarce prin edx numarul de vecini vii
         
         cmp $0, (%edi, %eax, 4)
         je inviere
         #daca a ajuns executia aici, celula mea e vie
         cmp $2, %edx
         je ramane_vie
         
         cmp $3, edx
         je ramane_vie
         
         jmp omoara_celula
         
       incl columnIndex
       jmp linieCurenta
     finalScriere:
        
        jmp linii
        #si ne intoarcem de unde am venit
exit:
  movl $1, %eax
  movl $0, %ebx
  int $0x80
   
   
  
