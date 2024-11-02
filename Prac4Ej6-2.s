.data
A: .word 2
B: .word 2
C: .word 1
D: .word 0
.code
;más rápido (20 ciclos en vez de 28), pero sólo funciona sin delay shot
;(con delay shot habría que agregar nops, lo que lo llevaría a 24 ciclos)
		ld r1, A(r0)
		ld r2, B(r0)
		ld r3, C(r0)
		daddi r6, r0, 3
		daddi r7, r0, 1
		beq r1, r2, no1
		daddi r6, r6, -1
no1:	beq r1, r3, no2
		daddi r6, r6, -1
no2:	beq r2, r3, no3
		daddi r6, r6, -1
no3:	bne r6, r7, fin
		daddi r6, r6, 1
fin:	sd r6, D(r0)
		halt