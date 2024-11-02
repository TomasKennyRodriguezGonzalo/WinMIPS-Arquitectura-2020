.data
M: .word 15
TABLA: .word 3, 76, 1, 4, 15, 93, 10, 3, 9, 44
CANT: .word 10
RESPUESTA_CORRECTA: .word 3
RESPUESTA: .word 0

.code
ld $a0, M($0)
daddi $a1, $0, TABLA
ld $a2, CANT($0)
jal Contar_Mayores
sd $v0, RESPUESTA($0)
halt

;$a0 recibe el valor a comparar M
;$a1 recibe la dirección de comienzo de la tabla
;$a2 recibe la cantidad de valores de la tabla
;$v0 devuelve la cantidad de números en la tabla mayores a M
Contar_Mayores: daddi $v0, $0, 0
dsll $a2, $a2, 3 ;Multiplicamos por 8
dadd $t0, $a2, $a1 ;$t0 contiene la dirección en la que termina la tabla
ContarMayoresLoop: ld $t1, 0($a1)
slt $t3, $t1, $a0
bnez $t3, ContarMayoresFinLoop
beq $t1, $a0, ContarMayoresFinLoop
daddi $v0, $v0, 1
ContarMayoresFinLoop: daddi $a1, $a1, 8
slt $t3, $a1, $t0
bnez $t3, ContarMayoresLoop
jr $ra

