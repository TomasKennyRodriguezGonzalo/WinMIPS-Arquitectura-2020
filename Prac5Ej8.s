.data
Cadena1: .asciiz "Hola a todos, Como les va?"
Cadena2: .asciiz "Hola a todes, Como les va?"
Pos_difiere: .word 0

.code
daddi $a0, $0, Cadena1
daddi $a1, $0, Cadena2
jal EncontrarDiferencia
sd $v0, Pos_difiere($0)
halt
;Recibe la dirección de comienzo de dos cadenas terminadas en 0 en $a0 y $a1
;Retorna en $v0 la posición (empezando en 1) en las cadenas del primer caracter en el que difieren
;Si no difieren, retorna -1 en $v0
EncontrarDiferencia: daddi $v0, $0, -1
daddi $t2, $0, 1
loop: lb $t0, 0($a0)
lb $t1, 0($a1)
beqz $t0, fin
beqz $t1, fin
beq $t0, $t1, LoopFin
daddi $v0, $t2, 0
j fin
LoopFin: daddi $t2, $t2, 1
daddi $a0, $a0, 1
daddi $a1, $a1, 1
j loop
fin: jr $ra