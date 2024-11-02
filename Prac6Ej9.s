;(Originalmente hecho el 1/12/2020)
;El ejercicio 9 de la práctica 6 de 2020 pedía extender la memoria para poder almacenar los pixeles
;pero esta solución lo hace con los 1024 bytes disponibles por defecto.
.data
CONTROL: .word32 0x10000, 0x10008

Pixeles: .space 938
;Los pixeles estan estructurados de la siguiente manera:
;76543210
;76543210
;76543210
;Cada 3 bytes, se cubren 8 pixeles.
;El primer byte contiene los LSB, el ultimo los MSB.
;...Tal vez sea mejor organizarlos así:
;22111000
;54443332
;77766655
;Son 2500 pixeles, organizados por filas
;(primero todos los de la primera fila, luego todos los de la segunda...)
;Para transformar de X a Y a numero de pixel,
;N = 50*Y+X
;(Entonces para el proceso inverso, Y = N / 50, X = N mod 50)
;Para localizar el bloque de un pixel, se divide N por 8
;Para localizar el bit, N mod 8

Teclas: .ascii "wasd 19"
Colores: .word32 0x00FFFFFF, 0x00000000, 0x00FF0000, 0x0000FF00, 0x000000FF, 0x00FF00FF, 0x0000FFFF, 0x00FFFF00

.code
daddi $s0, $0, 25 ;X
daddi $s1, $0, 25 ;Y
daddi $s2, $0, 0 ;Modo (0 = mover, 1 = pintar)
daddi $s3, $0, 1 ;Color (0-7)
daddi $s5, $0, CONTROL
lwu $s4, 0($s5) ;CONTROL
lwu $s5, 4($s5) ;DATA


loop: nop

;Si está en modo pintar... hay que actualizar el valor del pixel actual.
beq $s2, $0, NoPintar
daddi $a0, $s0, 0
daddi $a1, $s1, 0
daddi $a2, $s3, 0
jal PintarPixel

NoPintar: sb $s0, 5($s5) ; DATA+5 X
sb $s1, 4($s5) ; DATA+4 Y
dsll $t0, $s3, 2
lwu $t0, Colores($t0) ;Agarrar color
sw $t0, 0($s5) ; DATA color
daddi $t0, $0, 5 ;$función 5: pintar pixel
sd $t0, 0($s4) ; CONTROL recibe 5 y produce el dibujo del punto

daddi $t0, $0, 9 ;$función 9: ingresar caracter
sd $t0, 0($s4) ; CONTROL recibe 9 y pide un caracter
lbu $t0, 0($s5) ;Cargamos el caracter...
daddi $t1, $0, Teclas
daddi $t8, $s0, 0
daddi $t9, $s1, 0 ;guardamos el X e Y actuales
lbu $t2, 0($t1) ;"w"
beq $t0, $t2, arriba
lbu $t2, 3($t1) ;"d"
beq $t0, $t2, derecha
lbu $t2, 1($t1) ;"a"
beq $t0, $t2, izquierda
lbu $t2, 2($t1) ;"s"
beq $t0, $t2, abajo
lbu $t2, 4($t1) ;" "
beq $t0, $t2, espacio
lbu $t2, 6($t1) ;"8"
slt $t3, $t2, $t0 ;Saltamos alfin si es mayor o igual a "9"
bnez $t3, fin
lbu $t2, 5($t1) ;"1"
slt $t3, $t0, $t2 ;Saltamos al fin si es menor a "0"
bnez $t3, fin
numero: dsub $t0, $t0, $t2 ;Lo restringimos al rango 0-7
daddi $s3, $t0, 0
j fin

arriba: daddi $t3, $0, 49
daddi $s1, $s1, 1
slt $t4, $t3, $s1 ;si Y es mayor a 50, Y = 50
dsub $s1, $s1, $t4
j movido
izquierda: daddi $s0, $s0, -1
slt $t4, $s0, $0 ;si X es menor a 0, X = 0
dadd $s0, $s0, $t4
j movido
abajo: daddi $s1, $s1, -1
slt $t4, $s1, $0 ;si Y es menor a 0, Y = 0
dadd $s1, $s1, $t4
j movido
derecha: daddi $t3, $0, 49
daddi $s0, $s0, 1
slt $t4, $t3, $s0 ;si X es mayor a 50, X = 50
dsub $s0, $s0, $t4

movido: daddi $a0, $t8, 0
daddi $a1, $t9, 0
bne $s2, $0, fin
jal RestaurarPixel
j fin

espacio: daddi $t0, $0, 1
dsub $s2, $t0, $s2
j fin
fin:

j loop

halt


;PintarPixel
;Recibe en $a0 y en $a1 las coordenadas X e Y del pixel a pintar
;En $a2 recibe la ID del color
PintarPixel: 	daddi $t0, $0, Pixeles
				;t1 es el numero del pixel
				;N = 50*Y+X
				daddi $t1, $0, 50
				dmul $t1, $t1, $a1
				dadd $t1, $t1, $a0
				;t2 es la dirección del bloque
				daddi $t9, $0, 8
				ddiv $t2, $t1, $t9
				daddi $t9, $0, 3
				dmul $t2, $t2, $t9
				dadd $t2, $t2, $t0
				;t3 es el numero de pixel dentro del bloque... para eso se hace mod 8, que es lo mismo que aislar los primeros 3 bits
				andi $t3, $t1, 7 ; 7 = 0111
				
				;lwu $t4, 0($t2) ;Cargamos el bloque
				lbu $t0, 2($t2) ;Cargamos el tercer byte
				dsll $t4, $t0, 16
				lbu $t0, 1($t2) ;Cargamos el segundo byte
				dsll $t0, $t0, 8
				dadd $t4, $t4, $t0
				lbu $t0, 0($t2) ;Cargamos el primer byte
				dadd $t4, $t4, $t0
				
				daddi $t8, $0, 3
				dmul $t3, $t3, $t8 ;Multiplicamos por 3 el numero de pixel, para obtener la dirección del primer bit
				daddi $t0, $0, 7 ;Y agarramos 0111
				dsllv $a2, $a2, $t3 ;Los corremos hasta la posición correcta
				daddi $s7, $a2, 0
				dsllv $t0, $t0, $t3 ;Los corremos hasta la posición correcta
				
				or $t4, $t4, $t0 ;con un or lo dejamos en 1
				xor $t4, $t4, $t0 ;con un xor lo dejamos en 0
				or $t4, $t4, $a2 ;y con un or lo dejamos en el valor correcto
				
				;sw $t4, 0($t2) ;Y lo guardamos
				sb $t4, 0($t2) ;Guardamos el primer byte
				dsrl $t4, $t4, 8
				sb $t4, 1($t2) ;Guardamos el segundo byte
				dsrl $t4, $t4, 8
				sb $t4, 2($t2) ;Guardamos el tercer byte
				
				
				jr $ra
;

;RestaurarPixel
;Recibe en $a0 y en $a1 las coordenadas del pixel
;Y restaura su valor guardado
RestaurarPixel:	daddi $t0, $0, Pixeles
				;t1 es el numero del pixel
				;N = 50*Y+X
				daddi $t1, $0, 50
				dmul $t1, $t1, $a1
				dadd $t1, $t1, $a0
				;t2 es el la dirección del bloque
				daddi $t9, $0, 8
				ddiv $t2, $t1, $t9
				daddi $t9, $0, 3
				dmul $t2, $t2, $t9
				dadd $t2, $t2, $t0
				;t3 es el numero de pixel dentro del bloque... para eso se hace mod 8, que es lo mismo que aislar los primeros 3 bits
				andi $t3, $t1, 7 ; 7 = 0111
				
				;lwu $t4, 0($t2) ;Cargamos el bloque
				lbu $t0, 2($t2) ;Cargamos el tercer byte
				dsll $t4, $t0, 16
				lbu $t0, 1($t2) ;Cargamos el segundo byte
				dsll $t0, $t0, 8
				dadd $t4, $t4, $t0
				lbu $t0, 0($t2) ;Cargamos el primer byte
				dadd $t4, $t4, $t0
				
				daddi $t8, $0, 3
				dmul $t3, $t3, $t8 ;Multiplicamos por 3 el numero de pixel, para obtener la dirección del primer bit
				daddi $t0, $0, 7 ;Y agarramos 0111
				dsrlv $t4, $t4, $t3 ;Lo corremos hacia la posición correcta
				and $t0, $t0, $t4 ;Y buscamos el valor de los bits
				;ahora $t0 tiene el valor del color
				dsll $t0, $t0, 2
				lw $t0, Colores($t0)
				daddi $t2, $0, CONTROL
				lwu $t1, 0($t2) ;CONTROL
				lwu $t2, 4($t2) ;DATA
				
				sb $a0, 5($t2) ; DATA+5 X
				sb $a1, 4($t2) ; DATA+4 Y
				sw $t0, 0($t2) ; DATA color
				daddi $t0, $zero, 5 ; $t0 = 5 -> función 5: salida gráfica
				sd $t0, 0($t1) ; CONTROL recibe 5 y produce el dibujo del punto
				
				jr $ra
;





;BASURA
				lb $t4, 0($t2) ;Cargamos el primer byte del bloque
				andi $t5, $a2, 1 ;Tomamos el primer bit del color
				daddi $t0, $0, 1 ;Y un bit en 1
				dsllv $t0, $t0, $t3 ;Los corremos hacia la posicion del pixel
				dsllv $t5, $t5, $t3
				or $t4, $t4, $t0 ;con un or lo dejamos en 1
				and $t4, $t4, $t5 ;y con un and lo dejamos en el valor correcto
				sb $t4, 0($t2) ;Y lo guardamos
				
				lb $t4, 1($t2) ;Cargamos el segundo byte del bloque
				andi $t5, $a2, 2 ;Tomamos el segundo bit del color
				dsrl $t5, $t5, 1 ;Y lo corremos a la derecha para que sea 1
				dsllv $t5, $t5, $t3 ;Lo corremos hacia la posicion del pixel
				or $t4, $t4, $t0 ;con un or lo dejamos en 1
				and $t4, $t4, $t5 ;y con un and lo dejamos en el valor correcto
				sb $t4, 1($t2) ;Y lo guardamos
				
				lb $t4, 2($t2) ;Cargamos el segundo byte del bloque
				andi $t5, $a2, 4 ;Tomamos el segundo bit del color
				dsrl $t5, $t5, 2 ;Y lo corremos a la derecha para que sea 1
				dsllv $t5, $t5, $t3 ;Lo corremos hacia la posicion del pixel
				or $t4, $t4, $t0 ;con un or lo dejamos en 1
				and $t4, $t4, $t5 ;y con un and lo dejamos en el valor correcto
				sb $t4, 2($t2) ;Y lo guardamos











