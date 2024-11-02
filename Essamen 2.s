.data
Control: .word32 0x10000
Data: .word32 0x10008
RESUL: .word 0
Msj: .asciiz "Ingrese tres numeros enteros: " ;(Opcional)
.code
;(Opcional) Imprimimos el mensaje pidiendo los números
lwu $t0, Data($0) ;DATA
lwu $t1, Control($0) ;CONTROL
daddi $t3, $0, Msj
daddi $t2, $0, 4 ;función 4: imprimir cadena ascii
sd $t3, 0($t0) ;DATA recibe la dirección de la cadena
sd $t2, 0($t1) ;CONTROL recibe 4 y la imprime

;Pedimos realmente los números, y los guardamos en $s0, $s1 y $s2 (A, B y C respectivamente)
jal PEDIR_ENTERO
daddi $s0, $v0, 0
jal PEDIR_ENTERO
daddi $s1, $v0, 0
jal PEDIR_ENTERO
daddi $s2, $v0, 0

;Calculamos (A+B)^C y lo guardamos en $s3
daddi $s3, $0, 1
beqz $s2, fin ;Excepción: Si C = 0, el resultado es 1
dadd $s3, $s0, $s1 ;A+B
daddi $t0, $s3, 0 ;Copia de A+B
;Hacemos la potencia, asumiendo que C > 0
;La idea es multiplicar s3 por t0 repetidamente, decrementando C hasta que sea 1
;Para que sea más fácil comprobar C = 1, le restamos 1 a C de antemano, y comprobamos en su lugar si C = 0
daddi $s2, $s2, -1
loop: beqz $s2, fin
daddi $s2, $s2, -1
dmul $s3, $s3, $t0
j loop
fin: sd $s3, RESUL($0) ;Guardamos el resultado
jal MOSTRAR_RESULTADO
halt

;PEDIR_ENTERO
;Le pide un entero al usuario
;Lo devuelve en $v0
PEDIR_ENTERO: lwu $t0, Data($0) ;DATA 
lwu $t1, Control($0) ;CONTROL
daddi $t2, $0, 8 ;función 8: entrada de un número
sd $t2, 0($t1) ;CONTROL recibe 8 y pide un numero
ld $v0, 0($t0) ;Recuperamos el número pedido
jr $ra

;MOSTRAR_RESULTADO
;Muestra el numero entero almacenado en RESUL
MOSTRAR_RESULTADO: lwu $t0, Data($0) ;DATA 
lwu $t1, Control($0) ;CONTROL
ld $t3, RESUL($0)
daddi $t2, $0, 2 ;función 2: salida de entero con signo
sd $t3, 0($t0) ;DATA recibe el numero
sd $t2, 0($t1) ;CONTROL recibe 2 y lo muestra
jr $ra