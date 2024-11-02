.data
vocales: .ascii "aeiou"
caracter: .ascii "A"
respuesta: .word 0

.code
lb $a0, caracter($0)
jal ES_VOCAL
sd $v0, respuesta($0)
halt

;Recibe en $a0 el caracter a evaluar
;Devuelve en $v0 si es una vocal (1) o no (0)
ES_VOCAL: daddi $v0, $0, 0
daddi $t0, $0, 4
loop: lb $t1, vocales($t0)
ori $t1, $t1, 0x20
beq $t1, $a0, bien
xori $t1, $t1, 0x20
beq $t1, $a0, bien
beqz $t0, fin
daddi $t0, $t0, -1
j loop
bien: daddi $v0, $0, 1
fin: jr $ra
