.data
CONTROL: .word 0x10000
DATA: .word 0x10008
mensaje: .asciiz "Por favor, ingrese su clave: "
clave: .ascii "t6Oj"
asterisco: .asciiz "*"
ingreso: .space 4
bien: .asciiz "Bienvenido."
mal: .asciiz "ERROR\n"
NL: .word 10
.code
principio: ld $s2, CONTROL($0)
ld $s3, DATA($0)	
daddi $s4, $0, mensaje
sd $s4, 0($s3) ; pasamos la dirección a DATA
daddi $s1, $0, 4 ; función 4: salida de una cadena ASCII
sd $s1, 0($s2) ; CONTROL recibe 4 y produce la salida del mensaje
daddi $s4, $0, asterisco

daddi $s0, $0, 0
daddi $s5, $0, 4

loop: jal CHAR
sd $s4, 0($s3) ; guarda *
sd $s1, 0($s2) ; imprime *
sb $v0, ingreso($s0)
daddi $s0, $s0, 1
daddi $s5, $s5, -1
bnez $s5, loop

daddi $s4, $0, NL
sd $s4, 0($s3)
sd $s1, 0($s2)

jal RESPUESTA

bnez $v0, principio

halt

;CHAR
;Pide el ingreso de un caracter, y lo devuelve en $v0
;REQUIERE VARIABLES:
;CONTROL: .word 0x10000 y DATA: .word 0x10008
CHAR: 	ld $t0, CONTROL($0)
		ld $t1, DATA($0)
		daddi $t2, $0, 9 ;$función 9: ingresar caracter
		sd $t2, 0($t0) ;CONTROL recibe 9 y pide un caracter
		lb $v0, 0($t1) ;cargamos el caracter
		jr $ra
;

;imprime si está bien o mal, devuelve en $v0 0 si está bien, -1 si está mal
RESPUESTA:		ld $t8, CONTROL($0)
				ld $t9, DATA($0)				
				daddi $t7, $0, 4 ; función 4: salida de una cadena ASCII

				ld $t0, clave($0)
				ld $t1, ingreso($0)
				beq $t0, $t1, RESPUESTAbien
				;caso MAL
				daddi $v0, $0, -1
				daddi $t0, $0, mal
				j RESPUESTAfin
				;caso BIEN
RESPUESTAbien:	daddi $v0, $0, 0
				daddi $t0, $0, bien
RESPUESTAfin:	sd $t0, 0($t9) ; pasamos la dirección a DATA
				sd $t7, 0($t8) ; CONTROL recibe 4 y produce la salida del mensaje
				jr $ra
;






