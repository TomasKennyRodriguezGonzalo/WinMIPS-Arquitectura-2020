.data
CONTROL: .word 0x10000
DATA: .word 0x10008
PRINCIPIO: .ascii "0"
FIN: .ascii "9"
CERO: .asciiz "CERO"
.asciiz "UNO"
.asciiz "DOS"
.asciiz "TRES"
.asciiz "CUATRO"
.asciiz "CINCO"
.asciiz "SEIS"
.asciiz "SIETE"
.asciiz "OCHO"
.asciiz "NUEVE"
TABLA: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.code
jal INGRESO
daddi $a0, $v0, 0
jal MUESTRA
halt

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
				slt $t7, $t5, $v0 ;si el caracter es mayor a "9", esto da 1
				bnez $t6, INGRESOloop ;en ese caso, saltamos
				bnez $t7, INGRESOloop ;en ese caso, saltamos
				dsub $v0, $v0, $t4 ;lo convertimos a su valor numérico (0,1,2...9)
INGRESOfin: jr $ra


;MUESTRA
;recibe en a0 un caracter representando a un número, e imprime su nombre
;REQUIERE VARIABLES:
;CONTROL: .word 0x10000 y DATA: .word 0x10008
;CERO hasta NUEVE, valores .asciiz con los numeros "CERO" hasta "NUEVE"
MUESTRA:		ld $t0, CONTROL($0)
				ld $t1, DATA($0)
				lb $t2, PRINCIPIO($0)
				dsll $a0, $a0, 3 ;multiplicamos por 8
				daddi $t2, $0, CERO ;establecemos el puntero
				dadd $t2, $a0, $t2 ;y lo corremos dependiendo del número
				;ahora $t2 apunta a la cadena correcta (asumiendo que cada número ocupa 7 dígitos o menos)
				sd $t2, 0($t1) ;lo metemos en DATA
				daddi $t2, $0, 4 ;$función 4: salida de una cadena ASCII
				sd $t2, 0($t0) ; CONTROL recibe 4 y produce la salida del mensaje
MUESTRAfin:	jr $ra









