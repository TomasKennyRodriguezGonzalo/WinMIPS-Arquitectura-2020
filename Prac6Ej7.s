.data
;NUMEROS: .byte 28, 34, 34, 34, 34, 34, 34, 28
;.byte 0, 4, 28, 4, 4, 4, 4, 4
;.byte 30, 0, 56, 4, 2, 4, 8, 16
;.byte 32, 62, 0 ,30, 2, 2, 2, 30
;.byte 2, 2, 30, 34, 34, 34, 62, 2
;.byte 2, 2, 2, 0, 62, 32, 32, 32
;.byte 30, 2, 2, 62, 28, 32, 32, 28
;.byte 34, 34, 34, 28 ,30, 2, 4, 4
;.byte 8, 8, 16, 16, 0, 28, 34, 34
;.byte 28, 34, 34, 34, 28, 28, 34, 34
;.byte 30, 2, 2, 2, 2, 0
NUMEROS: .byte 28, 34, 34, 34, 34, 34, 34, 28, 0
UNO: .byte 4, 28, 4, 4, 4, 4, 4, 30, 0
DOS: .byte 56, 4, 2, 4, 8, 16, 32, 62, 0
TRES: .byte 28, 2, 2, 2, 30, 2, 2, 28, 0
CUATRO: .byte 34, 34, 34, 62, 2, 2, 2, 2, 0
CINCO: .byte 62, 32, 32, 32, 30, 2, 2, 62, 0
SEIS: .byte 28, 32, 32, 60, 34, 34, 34, 28, 0
SIETE: .byte 62, 2, 4, 4, 8, 8, 16, 16, 0
OCHO: .byte 28, 34, 34, 28, 34, 34, 34, 28, 0
NUEVE: .byte 28, 34, 34, 30, 2, 2, 2, 2, 0
CONTROL: .word32 0x10000
DATA: .word32 0x10008
NL: .word 10
PEDIR_RANGO_ERROR: .asciiz "FUERA DE RANGO."
MSJ: .asciiz "Ingrese un numero (0-9): "

.code

daddi $a0, $0, 0
daddi $a1, $0, 9
daddi $a2, $0, MSJ
jal PEDIR_RANGO
;limpiamos la pantalla alfanumérica
lwu $t0, CONTROL($0)
daddi $t1, $0, 6; Función 6: Limpiar pantalla alfanumérica
sd $t1, 0($t0)
;pasamos el número
daddi $a0, $v0, 0
daddi $a1, $0, 22
daddi $a2, $0, 25
jal DIBUJAR_NUMERO

halt

;DIBUJAR_NUMERO
;Recibe en a0 un numero del 0 al 9 y lo dibuja
;en la coordenada X = a1 e Y = a2
DIBUJAR_NUMERO: 	lwu $s0, CONTROL($0)
					lwu $s1, DATA($1)
					
					
					daddi $t9, $0, 7 ; función 7: limpiar pantalla gráfica
					sd $t9, 0($s0) ; CONTROL recibe 7 y limpia la pantalla gráfica
					daddi $t9, $0, 5 ; función 5: salida gráfica
					sb $a1, 5($s1) ; DATA+5 recibe el valor de coordenada X
					sw $0, 0($s1) ; DATA recibe el valor del color a pintar
					
					daddi $t2, $0, NUMEROS
					daddi $t3, $0, 16
					dmul $t3, $t3, $a0 ;t3 es el puntero
					dadd $t3, $t3, $t2
					daddi $t4, $0, 9 ;t4 contiene la línea actual a dibujar
					dadd $a2, $a2, $t4

DNUM_LINEA:			daddi $t4, $t4, -1
					daddi $a2, $a2, -1
					;a2 = Y
					sb $a2, 4($s1) ; DATA+4 recibe el valor de coordenada Y
					;t3 apunta al byte de la linea
					;t5 lo recibe
					lbu $t5, 0($t3)
					
					daddi $t6, $0, 7 ;t6 contine el punto a dibujar
					dadd $a1, $a1, $t6
					daddi $t7, $0, 0 ;t7 es el bit a leer
DNUM_PUNTO:			daddi $t6, $t6, -1
					daddi $a1, $a1, -1
					;t5 tiene un byte, y hay que ver si el bit n° t7 es 1 o 0
					daddi $t8, $0, 1
					dsllv $t8, $t8, $t7
					and $t8, $t8, $t5
					;si esto es 0, el bit es 0, así que salteamos dibujar el punto
					beqz $t8, DNUM_SkipDibujo
					;sino, lo dibujamos
					
					sb $a1, 5($s1) ; DATA+5 recibe el valor de coordenada X
					sd $t9, 0($s0) ; CONTROL recibe 5 y produce el dibujo del punto
					
DNUM_SkipDibujo:	daddi $t7, $t7, 1
					bnez $t6, DNUM_PUNTO
					
					
					daddi $t3, $t3, 1
					bnez $t4, DNUM_LINEA
					
					
					jr $ra
;


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