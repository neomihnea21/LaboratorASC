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
  cripto: .space 4
  mesaj:.space 84
  mesajCriptat: space 84
  formatString: "%s"
  formatRead: .asciz "%ld"
  formatWrite: .asciz "%ld "
  formatHexa: .asciz "%x"
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
  je citire
  movl $0, (%edi, %ebx, 4)
  incl i
  jmp initializare
citire:
   movl i, %ecx
   cmp %ecx, p
   je restCitire
   
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
finalCitire:
   pushl $k
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   pushl $cripto
   pushl $formatRead
   call scanf
   popl %ebx
   popl %ebx
   
   pushl $mesaj
   pushl $formatString
   call scanf
   popl %ebx
   popl %ebx
continuare:
  jmp exit
  movl $0, i 
  # i tine cate generatii am facut
  pasConway:
    #nu pun adresa lui newMatrix in ESI, ca sa fac o schema cu adrese la suprascriere
    movl i, %ecx
    cmp %ecx, k
    je schimbaMesaj
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
       buclaFinal:
          movl (%ebx, %ecx, 4), %esi
          movl %esi, (%edi, %eax, 4)
          add $1, %ecx
          cmp produs, %ecx
          jne buclaFinal
    incl i 
    jmp pasConway
# o sa arate neuzual, deoarece matricea e indexata de la 1, ca sa se bordeze    
mesaj:
  cmp cripto, $0
  je criptare
  jne decriptare
  criptare:
    lea matrix, %edi #sa fim noi siguri
    lea mesaj, %esi
    xorl %ecx, %ecx
    movl $0, i #vom folosi i ca sa tinem caracterul din mesaj pe care il xoram
    criptareUnCaracter:
      movl i, %edx
      cmp (%esi, %edx, 1), $0 #asa se compara un caracter cu terminatorul de sir?
      je scrieCifru
      xorl %edx, %edx
      movl $7, %edx #puterea lui 2
      movl $0, %eax
      cheie2: #combinam 8 biti pe tabla ca sa obtinem caracterul al doilea din xor in eax
        cmp %edx, -1
        je cheie1
        shl %edx, (%edi, %ecx, 4)
        addl (%edi, %ecx, 4), %eax #eax va tine caracterul din cheie, scris din celule
        incl %ecx
        decl %edx
        jmp cheie2
      cheie1: #caarcterul de pe poz corecta din mesaj, va fi in %ebx
        movl i, %edx
        movl (%esi, %edx, 1), %ebx
      xorl %eax, %ebx
      lea mesajCriptat, %edi
      movl(%edi, %edx, 1), %eax
      incl i
      cmp %ecx, produs
      jl resetECX
      jmp endReset
      resetECX: 
         movl $1, %ecx
       endReset:
      jmp criptareUnCaracter
     scrieCifru:
       pushl formatHexa
       pushl mesajCriptat
       call printf
       popl %ebx
       popl %ebx
     decriptare:
       
exit:
  movl $1, %eax
  movl $0, %ebx
  int $0x80

