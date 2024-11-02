.data
cadena: .asciiz "adbdcdedfdgdhdid" ; cadena a analizar
car: .asciiz "d" ; caracter buscado
cant: .word 0 ; cantidad de veces que se repite el caracter car en cadena.
.code
lbu r1, car(r0) ;caracter a buscar
daddi r2, r0, 0 ;offset
daddi r5, r0, 0 ;cantidad
loop: lbu r3, cadena(r2)
bne r3, r1, fin_loop
daddi r2, r2, 1 ;aprovechamos para hacer esto con delay slot
daddi r5, r5, 1
fin_loop: bnez r3, loop
sd r5, cant(r0)
halt