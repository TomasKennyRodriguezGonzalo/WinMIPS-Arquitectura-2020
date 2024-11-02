.data
CONTROL: .word 0x10000
DATA: .word 0x10008
PRINCIPIO: .ascii "0"
FIN: .ascii "9"
N1: .word 0
N2: .word 0
.code
jal INGRESO
daddi $a0, $v0, 0
jal INGRESO
daddi $a1, $v0, 0
jal RESULTADO
halt




;RESULTADO
;recibe en a0 y a1 dos números, los suma, y muestra el resultado en la terminal
;REQUIERE VARIABLES:
;CONTROL: .word 0x10000 y DATA: .word 0x10008
RESULTADO: ld $t0, CONTROL($0)
ld $t1, DATA($0)
dadd $t2, $a0, $a1
sd $t2, 0($t1)
daddi $t2, $0, 1 ;funcion 0: mostrar número con signo (no importa si es con o sin en este caso)
sd $t2, 0($t0)
jr $ra

;INGRESO
;pide que se ingrese un número, y lo devuelve en v0
;si no se da un número, sigue pidiendo hasta que se lo de
;REQUIERE VARIABLES:
;CONTROL: .word 0x10000 y DATA: .word 0x10008
;PRINCIPIO: .ascii "0" y FIN: .ascii "9"
INGRESO: 		ld $t0, CONTROL($0)
				ld $t1, DATA($0)
				daddi $t2, $0, 9 ;$función 9: ingresar caracter
				lb $t4, PRINCIPIO($0) ;t4 = "0"
				lb $t5, FIN($0); t5 = "9"
INGRESOloop:	sd $t2, 0($t0) ;CONTROL recibe 9 y pide un caracter
				lb $v0, 0($t1) ;cargamos el caracter
				slt $t6, $v0, $t4 ;si el caracter es menor a "0", esto da 1
				bnez $t6, INGRESOloop ;en ese caso, saltamos
				slt $t6, $t5, $v0 ;si el caracter es mayor a "9", esto da 1
				bnez $t6, INGRESOloop ;en ese caso, saltamos
				dsub $v0, $v0, $t4 ;lo convertimos a su valor numérico (0,1,2...9)
INGRESOfin: jr $ra










