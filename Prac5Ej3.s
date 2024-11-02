.data
base: .double 5.85
altura: .double 13.47
respuesta: .double 0.0
respuesta_correcta: .double 39.39975
n_05: .double 0.5
.code
l.d f0, base(r0)
l.d f1, altura(r0)
l.d f2, n_05(r0)
mul.d f3, f0, f1
mul.d f3, f3, f2
s.d f3, respuesta(r0)
halt

