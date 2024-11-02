.data
X: .word 15
TABLA: .word 3, 76, 1, 4, 15, 93, 10, 3, 9, 44
CANT: .word 0
RESPUESTA_CORRECTA: .word 3
RES: .word 0,0,0,0,0,0,0,0,0,0

.code
daddi r2, r0, 80 ;10*8
daddi r5, r0, 0
ld r1, X(r0)
loop: daddi r2, r2, -8
ld r3, TABLA(r2)
daddi r4, r0, 0
beq r3, r1, fin_loop
slt r4, r1, r3
fin_loop: sd r4, RES(r2)
dadd r5, r5, r4
bnez r2, loop
sd r5, CANT(r0)
halt
