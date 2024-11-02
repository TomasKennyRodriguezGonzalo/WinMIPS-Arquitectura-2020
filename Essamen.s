.data
NUM1: .word 15
NUM2: .word 18
RESULTADO: .word 0
RESPUESTA_CORRECTA: .word 270 ;Esta variable no es necesaria, pero la agrego para que el simulador muestre 270 en hexadecimal y sea fácil comprobar si RESULTADO nos dio bien
.code

;cargamos los numeros
ld $t0, NUM1($0)
ld $t1, NUM2($0)
daddi $t2, $0, 0 ;Resultado

;t1 es el que se va a decrementar sucesivamente, así que para ser eficientes, si t0 < t1 intercambiamos sus valores
slt $t3, $t0, $t1
beqz $t3, calculo ;si t0 es mayor o igual a t1, vamos directo al calculo, sino...
daddi $t3, $t0, 0
daddi $t0, $t1, 0
daddi $t1, $t3, 0

calculo: beqz $t1, fin
loop: daddi $t1, $t1, -1
dadd $t2, $t2, $t0
bnez $t1, loop
fin: sd $t2, RESULTADO($0)
halt