.data
CONTROL: .word 0x10000
DATA: .word 0x10008
NL: .word 10
MSJ1: .asciiz "Ingrese un numero con coma: "
MSJ2: .asciiz "Ingrese un numero entero positivo: "
UNO: .double 1.0
CERO: .double 0.0
RESUL: .double 0.0
.code
ld $s0, CONTROL($0)
ld $s1, DATA($0)	
daddi $t1, $0, MSJ1 ; posición del primer mensaje
sd $t1, 0($s1) ; posición del primer mensaje
daddi $t0, $0, 4 ;función 4: salida de una cadena ASCII
sd $t0, 0($s0) ; manda el primer mensaje

daddi $t2, $0, 8 ;función 8: entrada de un número
sd $t2, 0($s0) ; se pide el número flotante
l.d f9, 0($s1) ; se lo carga

daddi $t1, $0, NL ; posición de la nueva línea
sd $t1, 0($s1) ; posición de la nueva línea
daddi $t0, $0, 4 ;función 4: salida de una cadena ASCII
sd $t0, 0($s0) ; manda la nueva línea

daddi $t1, $0, MSJ2 ; posición del segundo mensaje
sd $t1, 0($s1) ; posición del segundo mensaje
daddi $t0, $0, 4 ;función 4: salida de una cadena ASCII
sd $t0, 0($s0) ; manda el segundo mensaje


daddi $t2, $0, 8 ;función 8: entrada de un número
sd $t2, 0($s0) ; se pide el número entero
ld $a0, 0($s1) ; se lo carga

jal a_la_potencia
s.d f10, RESUL($0)

daddi $t1, $0, NL ; posición de la nueva línea
sd $t1, 0($s1) ; posición de la nueva línea
daddi $t0, $0, 4 ;función 4: salida de una cadena ASCII
sd $t0, 0($s0) ; manda la nueva línea

s.d f10, 0($s1) ; resultado
daddi $t0, $0, 3 ;función 3: salida de un número con coma
sd $t0, 0($s0) ; manda el segundo mensaje

halt



;recibe en f9 un numero de punto flotante
;y en $a0 un numero entero al que elevarlo
;devuelve en f10 el resultado
a_la_potencia: beqz $a0, alp_cero ;si es 0, el resultado es 1
l.d f10, CERO($0)
daddi $a0, $a0, -1
add.d f10, f9, f10
beqz $a0, alp_fin
alp_loop: daddi $a0, $a0, -1
mul.d f10, f10, f9
bnez $a0, alp_loop


alp_fin: jr $ra
alp_cero: l.d f10, UNO($0)
jr $ra



















