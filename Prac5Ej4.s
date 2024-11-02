.data
peso: .double 78.5
estatura: .double 1.66
IMC: .double 0.0
estado: .word 0
Limites: .double 18.5, 25.0, 30.0

.code
;Cargamos los datos
l.d f0, estatura(r0)
l.d f1, peso(r0)
;Calculamos el IMC
mul.d f2, f0, f0
div.d f2, f1, f2
s.d f2, IMC(r0)
;Comprobamos el estado
daddi $t0, $0, 1
daddi $t1, $0, 0

;Si es infrapeso
l.d f3, Limites($t1)
c.lt.d f2, f3
bc1t fin

;Si es normal
daddi $t0, $t0, 1
daddi $t1, $t1, 8
l.d f3, Limites($t1)
c.lt.d f2, f3
bc1t fin

;Si es obeso
daddi $t0, $t0, 1
daddi $t1, $t1, 8
l.d f3, Limites($t1)
c.lt.d f2, f3
bc1t fin

;Si es sobrepeso
daddi $t0, $t0, 1

fin: nop
sd $t0, estado($0)
halt

