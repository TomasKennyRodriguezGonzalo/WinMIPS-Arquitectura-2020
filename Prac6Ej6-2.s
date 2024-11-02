.data
coorX: .byte 24 ; coordenada X de un punto
coorY: .byte 24 ; coordenada Y de un punto
color: .byte 255, 0, 255, 0 ; color: máximo rojo + máximo azul => magenta
CONTROL: .word32 0x10000
DATA: .word32 0x10008
NL: .word 10
PEDIR_RANGO_ERROR: .asciiz "FUERA DE RANGO."
MSJX: .asciiz "Ingrese la coordenada X (0-49): "
MSJY: .asciiz "Ingrese la coordenada Y (0-49): "
MSJR: .asciiz "Ingrese el valor del color rojo (0-255): "
MSJG: .asciiz "Ingrese el valor del color verde (0-255): "
MSJB: .asciiz "Ingrese el valor del color azul (0-255): "
.text

daddi $a0, $0, 0
daddi $a1, $0, 49
daddi $a2, $0, MSJX
jal PEDIR_RANGO
sb $v0, coorX($0)

daddi $a0, $0, 0
daddi $a1, $0, 49
daddi $a2, $0, MSJY
jal PEDIR_RANGO
sb $v0, coorY($0)

daddi $a0, $0, 0
daddi $a1, $0, 255
daddi $a2, $0, MSJR
jal PEDIR_RANGO
sb $v0, color($0)

daddi $a0, $0, 0
daddi $a1, $0, 255
daddi $a2, $0, MSJG
jal PEDIR_RANGO
daddi $t0, $0, 1
sb $v0, color($t0)

daddi $a0, $0, 0
daddi $a1, $0, 255
daddi $a2, $0, MSJB
jal PEDIR_RANGO
daddi $t0, $0, 2
sb $v0, color($t0)


lwu $s6, CONTROL($zero) ; $s6 = dirección de CONTROL
lwu $s7, DATA($zero) ; $s7 = dirección de DATA
daddi $t0, $zero, 7 ; $t0 = 7 -> función 7: limpiar pantalla gráfica
sd $t0, 0($s6) ; CONTROL recibe 7 y limpia la pantalla gráfica
lbu $s0, coorX($zero) ; $s0 = valor de coordenada X
sb $s0, 5($s7) ; DATA+5 recibe el valor de coordenada X
lbu $s1, coorY($zero) ; $s1 = valor de coordenada Y
sb $s1, 4($s7) ; DATA+4 recibe el valor de coordenada Y
lwu $s2, color($zero) ; $s2 = valor de color a pintar
sw $s2, 0($s7) ; DATA recibe el valor del color a pintar
daddi $t0, $zero, 5 ; $t0 = 5 -> función 5: salida gráfica
sd $t0, 0($s6) ; CONTROL recibe 5 y produce el dibujo del punto
halt


;PEDIR_RANGO
;Recibe en $a0 el mínimo y en $a1 el máximo
;Recibe en $a2 la dirección del mensaje introductorio, o -1 si no debe haber mensaje
;Pide un número repetidamente hasta que esté dentro del rango
;Y lo devuelve en $v0
PEDIR_RANGO: 		lwu $t0, CONTROL($0)
					lwu $t1, DATA($1)
					slti $t2, $a2, 0
					bnez $t2, PedirRangoEntrada

					daddi $t2, $0, 4 ;función 4: salida de una cadena ASCII
					daddi $t4, $0, 2 ;función 2: salida de un número con signo
					sd $a2, 0($t1) ; dir del mensaje
					sd $t2, 0($t0) ; manda el mensaje
					
PedirRangoEntrada: 	daddi $t2, $0, 8 ;función 8: entrada de un número
					sd $t2, 0($t0) ; se pide el número entero
					ld $v0, 0($t1) ; se lo carga
					slt $t3, $v0, $a0 ;Si es menor al mínimo
					bnez $t3, PedirRangoError ;Error
					slt $t3, $a1, $v0 ;Si el máximo es menor que el número
					bnez $t3, PedirRangoError ;Error

					jr $ra
					
PedirRangoError: 	daddi $t2, $0, 4 ;función 4: salida de una cadena ASCII
					daddi $t3, $0, PEDIR_RANGO_ERROR
					sd $t3, 0($t1) ; dir del mensaje de error
					sd $t2, 0($t0) ; manda el mensaje
					daddi $t3, $0, NL
					sd $t3, 0($t1) ; dir de la nueva linea
					sd $t2, 0($t0) ; manda el caracter
					j PEDIR_RANGO
;




