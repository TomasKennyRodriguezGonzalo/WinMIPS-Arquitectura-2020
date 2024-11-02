.data
CONTROL: .word32 0x10000
DATA: .word32 0x10008
;texto: .asciiz "Hola, Mundo!" ; El mensaje a mostrar
CAR_FIN: .ascii "+"
BUFFER: .word 0
.code
lwu $s0, DATA($zero) ; $s0 = dirección de DATA
lwu $s1, CONTROL($zero) ; $s1 = dirección de CONTROL
daddi $t0, $zero, 9 ; $función 9: ingresar caracter
daddi $sp, $0, 0x400 ; establecemos la pila
daddi $s2, $0, 0 ;offset del buffer
daddi $t4, $0, 8 ;valor tope del offset
lb $t2, CAR_FIN($0) ;cargamos el caracter que hace que el mensaje se considere acabado

daddi $sp, $sp, -8 ;ponemos un 0 al final de todo
sd $0, 0($sp)
daddi $s3, $sp, -8 ;guardamos la dirección de inicio del mensaje en s3
loop:		sd $t0, 0($s1) ; Ingresa un caracter
			lbu $t1, 0($s0) ; Lo leemos
			beq $t2, $t1, loopFin ;Si es el último caracter, fin del loop
			;sino... lo guardamos en el buffer
			sb $t1, BUFFER($s2)
			daddi $s2, $s2, 1
			bne $s2, $t4, loop
			;si el offset ya es 8, guardamos el buffer en la pila y lo limpiamos
			daddi $sp, $sp, -8
			ld $t9, BUFFER($0)
			sd $t9, 0($sp)
			sd $0, BUFFER($0)
			daddi $s2, $0, 0
			j loop
loopFin:	nop

;si quedó algo en el buffer, lo agregamos a la pila
beq $s2, $t4, seguimos
ld $t0, BUFFER($0)
;dsll $t0, $s2, 3
;dsllv $t0, $t9, $t0
daddi $sp, $sp, -8
sd $t0, 0($sp)

;ahora, damos vuelta todo sp, para que los caracteres queden ordenados
seguimos: daddi $t0, $sp, 0 ;dirección del fin del sp
daddi $t1, $s3, 0 ;dirección del principio del sp en lo que al mensaje concierne
loop2:		ld $t2, 0($t0)
			ld $t3, 0($t1)
			sd $t2, 0($t1)
			sd $t3, 0($t0)
			daddi $t0, $t0, 1
			daddi $t1, $t1, -1
			slt $t4, $t0, $t1
			bnez $t4, loop2
loop2Fin:	
daddi $t0, $sp, 0 ; $t0 = dirección del mensaje a mostrar
sd $t0, 0($s0) ; DATA recibe el puntero al comienzo del mensaje
daddi $t0, $zero, 6 ; $t0 = 6 -> función 6: limpiar pantalla alfanumérica
sd $t0, 0($s1) ; CONTROL recibe 6 y limpia la pantalla
daddi $t0, $zero, 4 ; $t0 = 4 -> función 4: salida de una cadena ASCII
sd $t0, 0($s1) ; CONTROL recibe 4 y produce la salida del mensaje
halt
