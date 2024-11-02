.data
tabla: .word 5, 1, 25, 34, 99, 12354, 3, 2, 8, 40, 0
respuesta: .word 0
respuesta_correcta: .word 5

.code
daddi $sp, $0, 0x400
daddi $a0, $0, tabla
jal contar_impares
sd $v0, respuesta($0)
halt
;recibe en $a0 la dirección de una tabla de números terminada en 0
;devuelve en $v0 la cantidad de números impares en la tabla
contar_impares: daddi $sp, $sp, -8
sd $ra, 0($sp)
daddi $s0, $0, 0 ;puntero
daddi $s1, $0, 0 ;cantidad
loop: ld $a1, tabla($s0)
beqz $a1, fin
jal es_impar
dadd $s1, $s1, $v1
daddi $s0, $s0, 8
j loop
fin: daddi $v0, $s1, 0
ld $ra, 0($sp)
daddi $sp, $sp, 8
jr $ra

;recibe un número en $a1
;devuelve 1 en $v1 si es impar, 0 de lo contrario
es_impar: andi $v1, $a1, 1
jr $ra

