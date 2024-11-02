.data
A: .word 5
X: .word 6
Y: .word 20
RESUL_CHECK: .word 106
.code
		ld r1, A(r0)
		ld r2, X(r0)
		ld r3, Y(r0)
;slt rd, rg, rg -> rd = 1 si rf < rg
loop:	slt r4, r0, r1 ; r4 = 1 si 0 < A <-> r4 = 1 si A > 0
		beqz r4, fin
		daddi r1, r1, -1
		dadd r2, r2, r3
		j loop
fin:	sd r0, A(r0)
		sd r2, X(r0)
halt