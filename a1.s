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
  formatWrite: .asciz "%ld "
  newline: .asciz "\n"
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
  je preCitire
  movl $0, (%edi, %ebx, 4)
  incl i
  jmp initializare
preCitire:
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
   pushl $k
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   # acum sa incheiem citirea, care era gresita
  movl $0, i 
  # i tine cate generatii am facut
  pasConway:
    #nu pun adresa lui newMatrix in ESI, ca sa fac o schema cu adrese la suprascriere
    movl i, %ecx
    cmp %ecx, k
    je scriere
    # daca am facut k generatii, scrie ce avem
    #parcurgem matricea cu variabilele lineIndex si columnIndex
    movl $1, lineIndex
   C_linii:
     movl lineIndex, %ebx
     cmp %ebx, m
     jg finalPas
     movl $1, columnIndex
     #parcurgem linia la care suntem in lineIndex
     C_linieCurenta:
       movl columnIndex, %ebx
       cmp n, %ebx
       jg finalGeneratie
       movl lineIndex, %eax
       xorl %edx, %edx
       mull n
       addl columnIndex, %eax
       #am scos in eax indicele de lucru, in ecx va fi valoarea celulei de la indice
       movl $newMatrix, %ebx
       lea matrix, %edi
       movl %eax, %ecx
       generatieUrmatoare:
         #edx e gata 0
         verificaVecini:
           #vom intoarce prin edx numarul de vecini vii
           #incepem cu un soi de vecin 0, stanga-sus
           subl n, %ecx
           subl $1, %ecx
           cmp $1, (%edi, %ecx, 4)
           jne vecin1
           incl %edx
           #facem o schema inteligenta: daca e 0 (sau nu e 1, pe matricea binara), mergem direct la vecinul urmator, altfel, marim edx si se ajunge tot acolo, ca e et imediat
           vecin1:
              #centru-sus
              addl $1, %ecx
              cmp $1, (%edi, %ecx, 4)
              jne vecin2
              incl %edx
           vecin2:
              #dreapta-sus
              addl $1, %ecx
              cmp $1, (%edi, %ecx, 4)
              jne vecin3
              incl %edx
           vecin3:
              #dreapta-centru
              addl n, %ecx
              cmp $1, (%edi, %ecx, 4)
              jne vecin4
              incl %edx
           vecin4:
              #dreapta-jos
              addl n, %ecx
              cmp $1, (%edi, %ecx, 4)
              jne vecin5
              incl %edx
           vecin5:
              #centru-jos
              subl $1, %ecx
              cmp $1, (%edi, %ecx, 4)
              jne vecin6
              incl %edx
           vecin6:
              #stanga-jos
              subl $1, %ecx
              cmp $1, (%edi, %ecx, 4)
              jne vecin7
              incl %edx
            vecin7:
              #stanga-centru
              subl n, %ecx
              cmp $1, (%edi, %ecx, 4)
              jne terminaVecini
              incl %edx
         terminaVecini:
         cmp $0, (%edi, %eax, 4)
         je moarta
         #daca a ajuns executia aici, celula mea e vie
         cmp $2, %edx
         je ramane_vie
         
         cmp $3, %edx
         je ramane_vie
         #daca nu a avut 2 sau 3 vecini, va trebui omorata
         jmp omoara_celula
         moarta: 
             cmp $3, %edx
             je ramane_vie
         omoara_celula:
             # vom pune 0 in noua matrice, o facem dintr-o singura bucata
             movl $0, (%ebx, %ecx, 4)
             jmp incheieCelula
         ramane_vie:
             movl $1, (%ebx, %ecx, 4)
             jmp incheieCelula
       incheieCelula:     
       incl columnIndex 
       jmp C_linieCurenta
       finalGeneratie: 
          movl $0, columnIndex
          incl lineIndex
          jmp C_linii
    finalPas:
       #just in case, ne aranjam registrii
       pregatireFinal:
       xorl %esi, %esi
       xorl %ecx, %ecx
       addl $1, %ecx
       buclaFinal:
	  cmp %ecx, produs
	  je reiaPas
	  movl (%ebx, %ecx, 4), %esi
	  movl %esi, (%edi, %ecx, 4)
	  addl $1, %ecx
          jmp buclaFinal
    reiaPas:
    incl i 
    jmp pasConway
# o sa arate neuzual, deoarece matricea e indexata de la 1, ca sa se bordeze    
scriere:
   movl $1, lineIndex
   linii:
     movl lineIndex, %ebx
     cmp %ebx, m
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
       #am pus in eax indicele unde scriem 
       pushl %eax
       pushl formatWrite
       call printf
       popl %ebx
       popl %ebx
       #am scris, avansam 1 pe linie si da-i
       incl columnIndex
       jmp linieCurenta
     finalScriere:
        movl $4, %eax
        movl $1, %ebx
        movl $newline, %ecx
        movl $2, %edx
        int $0x80
        incl lineIndex
        jmp linii
        #scriem cu syscall un \n si ne intoarcem de unde am venit, pe linia urmatoare
exit:
  movl $1, %eax
  movl $0, %ebx
  int $0x80
