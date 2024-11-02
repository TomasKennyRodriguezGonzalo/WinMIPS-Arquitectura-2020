.data
vocales: .ascii "aeiou"
cadena: .asciiz "Hola GENTEEEE como estAAaaAAAaan amigooosoooos!!!"
respuesta: .word 0
respuesta_correcta: .word 28

.code
daddi $sp, $0, 0x400
daddi $a0, $0, cadena
jal CONTAR_VOC
sd $v0, respuesta($0)
halt

;Recibe en $a0 la dirección de una cadena terminada en 0
;Devuelve en $v0 la cantidad de vocales de la cadena
CONTAR_VOC:			daddi $sp, $sp, -32
					sd $ra, 0($sp)
					sd $s0, 8($sp)
					sd $s1, 16($sp)
					sd $s2, 24($sp)
					
					daddi $s0, $a0, 0 ;puntero
					daddi $s1, $0, 0 ;valor de retorno
					lb $s2, 0($s0)
CONTAR_VOCloop:		beqz $s2, CONTAR_VOCfin
					daddi $a0, $s2, 0
					jal ES_VOCAL
					dadd $s1, $s1, $v0
					daddi $s0, $s0, 1
					lb $s2, 0($s0)
					j CONTAR_VOCloop
					
CONTAR_VOCfin:		daddi $v0, $s1, 0
					
					ld $ra, 0($sp)
					ld $s0, 8($sp)
					ld $s1, 16($sp)
					ld $s2, 24($sp)
					daddi $sp, $sp, 32
					jr $ra
					
					
;Recibe en $a0 el caracter a evaluar
;Devuelve en $v0 si es una vocal (1) o no (0)
ES_VOCAL:		daddi $t0, $0, 4
				lb $t1, vocales($t0)
				daddi $v0, $0, 0
				
ES_VOCALloop: 	ori $t1, $t1, 0x20
				xori $t2, $t1, 0x20
				beq $t1, $a0, ES_VOCALbien
				beq $t2, $a0, ES_VOCALbien
				beqz $t0, ES_VOCALfin
				daddi $t0, $t0, -1
				lb $t1, vocales($t0)
				j ES_VOCALloop
ES_VOCALbien:	daddi $v0, $0, 1
ES_VOCALfin:	jr $ra
