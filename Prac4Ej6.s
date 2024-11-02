.data
A: .word 2
B: .word 2
C: .word 1
D: .word 0
.code
ld r1, A(r0)
ld r2, B(r0)
ld r3, C(r0)
daddi r6, r0, 3
slt r4, r1, r2
slt r5, r2, r1
dsub r6, r6, r4
dsub r6, r6, r5
slt r4, r1, r3
slt r5, r3, r1
dsub r6, r6, r4
dsub r6, r6, r5
slt r4, r2, r3
slt r5, r3, r2
dsub r6, r6, r4
dsub r6, r6, r5

daddi r7, r0, 1
slt r4, r6, r7
slt r5, r7, r6
dadd r4, r4, r5
xori r4, r4, 1
dadd r6, r6, r4
sd r6, D(r0)
halt
;si todos son iguales, r4-9 van a ser cero unos
;si dos números son iguales, r4-9 va a tener dos unos
;si son todos distintos, r4-9 va a tener tres unos
;tengo que mapear (0,2,3) a (3,2,0)
;o, mapear (3,1,0) a (3,2,0)... ya fue
;para comparar
