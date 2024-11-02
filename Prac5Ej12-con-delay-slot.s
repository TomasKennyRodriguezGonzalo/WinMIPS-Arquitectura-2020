.data
valor: .word 10
result: .word 0
result_correcto: .word 3628800
.text
daddi $sp, $zero, 0x400 ; Inicializa puntero al tope de la pila
ld $a0, valor($zero)
jal factorial
nop
sd $v0, result($zero)
halt
factorial: beqz $a0, factorialPatras
nop
daddi $sp, $sp, -8
sd $ra, 0($sp)
jal factorial
daddi $a0, $a0, -1
daddi $a0, $a0, 1
dmul $v0, $v0, $a0
ld $ra, 0($sp)
jr $ra
daddi $sp, $sp, 8
factorialPatras: jr $ra
daddi $v0, $0, 1
nop
