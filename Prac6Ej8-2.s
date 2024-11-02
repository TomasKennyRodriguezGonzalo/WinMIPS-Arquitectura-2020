.data
CONTROL: .word32 0x10000
DATA: .word32 0x10008
Azul: .word32 0x00FF0000 ; Azul
Verde: .word32 0x0000FF00 ; Verde
Rojo: .word32 0x000000FF ; Rojo
Magenta: .word32 0x00FF00FF ; Magenta
Amarillo: .word32 0x0000FFFF ; Amarillo
Celeste: .word32 0x00FFFF00 ; Celeste
Blanco: .word32 0x00FFFFFF ; Blanco
Direcciones: .word 0x21000122, 0x22210001
;Direcciones: .word 0x22222222, 0x22222222
PrincipioPelotas: .word 0
FinalPelotas: .word 0
;Una pelota tiene 5 características:
;Color (4 bytes), coordenadas X e Y (2 bytes), y dirección x e y (2 bytes)
;En total se puede almacenar toda su información en 8 bytes, es decir una doble palabra:
;Pelota = yxYXABGR en la memoria, o
;00 00 23 01 00 ff 00 00
;y  x  Y  X  A  B  G  R
;RGBAXYxy para acceder a los bytes en orden
;La dirección puede ser -1, 0 o 1, pero se guarda como 0, 1 o 2 respectivamente, así que se debe restar 1 en el código que la carge

.text
lwu $s6, CONTROL($zero)
lwu $s7, DATA($zero)

daddi $sp, $0, 0x400 ;inicializamos el stack

sd $sp, PrincipioPelotas($0) ;Empezamos a agregar pelotas, así que guardamos el "principio" de la lista que es la dirección de $sp

daddi $a0, $0, 23 ; Coordenada X de la pelota
daddi $a1, $0, 10 ; Coordenada Y de la pelota
daddi $a2, $0, 7 ; Dirección de la pelota
lwu $a3, Azul($0) ; Color de la pelota
jal AgregarPelota
daddi $a0, $0, 6 ; Coordenada X de la pelota
daddi $a1, $0, 8 ; Coordenada Y de la pelota
daddi $a2, $0, 1 ; Dirección de la pelota
lwu $a3, Verde($0) ; Color de la pelota
jal AgregarPelota
daddi $a0, $0, 4 ; Coordenada X de la pelota
daddi $a1, $0, 35 ; Coordenada Y de la pelota
daddi $a2, $0, 2 ; Dirección de la pelota
lwu $a3, Amarillo($0) ; Color de la pelota
jal AgregarPelota
daddi $a0, $0, 25 ; Coordenada X de la pelota
daddi $a1, $0, 25 ; Coordenada Y de la pelota
daddi $a2, $0, 0 ; Dirección de la pelota
lwu $a3, Magenta($0) ; Color de la pelota
jal AgregarPelota
daddi $a0, $0, 47 ; Coordenada X de la pelota
daddi $a1, $0, 47 ; Coordenada Y de la pelota
daddi $a2, $0, 3 ; Dirección de la pelota
lwu $a3, Rojo($0) ; Color de la pelota
jal AgregarPelota
daddi $a0, $0, 18 ; Coordenada X de la pelota
daddi $a1, $0, 10 ; Coordenada Y de la pelota
daddi $a2, $0, 4 ; Dirección de la pelota
lwu $a3, Celeste($0) ; Color de la pelota
jal AgregarPelota

sd $sp, FinalPelotas($0) ;Guardamos el final de la lista

loop: ld $s0, PrincipioPelotas($0)
ld $s1, FinalPelotas($0)

;Iteramos por la lista de pelotitas, y les hacemos dar un paso
Iter: 	daddi $s0, $s0, -8
		daddi $a0, $s0, 0
		jal PASO
		bne $s0, $s1, Iter
;

;Demora para bajar los FPS
daddi $t0, $zero, 3000 ; Hace una demora para que el rebote no sea tan rápido.
demora: daddi $t0, $t0, -1 ; Esto genera una infinidad de RAW y BTS pero...
bnez $t0, demora ; ¡hay que hacer tiempo igualmente!
j loop

;daddi $s0, $zero, 23 ; Coordenada X de la pelota
;daddi $s1, $zero, 1 ; Coordenada Y de la pelota
;daddi $s2, $zero, 1 ; Dirección X de la pelota
;daddi $s3, $zero, 1 ; Dirección Y de la pelota
;lwu $v0, color_pelota($zero)



;AgregarPelota
;Agrega una pelota al stack. CAMBIA EL STACK, SE DEBE RESTABLECER FUERA.
;Primera llamada: AgregarPelota
;a0: Coordenada X de la pelota
;a1: Coordenada Y de la pelota
;a2: Dirección (de 0 a 8, en dirección de las agujas del reloj)
;a3: Color RGBA (ABGR en codigo)
AgregarPelota: 	daddi $sp, $sp, -8
				;t1 guarda la primera mitad, t5 la segunda
				daddi $t1, $a3, 0 ;Color
				dsll $t0, $a0, 0 ;X
				dadd $t5, $0, $t0
				dsll $t0, $a1, 8 ;Y
				dadd $t5, $t5, $t0
				;Ahora desciframos la dirección
				;de 0 a 8...
				;X = 1 1 0 -1 -1 -1 0 1 ... Y = 0 1 1 1 0 -1 -1 -1
				;si -1 = 0000 = 0, 0 = 0001 = 1, 1 = 0010 = 2, y teniendo en cuenta que se ordenan al reves
				;X = 0x21000122 ... Y = 0x00012221
				;Estos valores están almacenados en la variable Direcciones
				;Para acceder por ejemplo a la dirección X, se desplaza el numero X, 4*D bits a la derecha, y se hace una mascara AND con 11 = 3
				daddi $t2, $0, Direcciones
				ld $t3, 0($t2) ;Cargamos la mascara X
				dsll $a2, $a2, 2 ;Multiplicamos por 4
				dsrlv $t3, $t3, $a2
				andi $t3, $t3, 3
				ld $t4, 8($t2) ;Cargamos la mascara Y
				dsrlv $t4, $t4, $a2
				andi $t4, $t4, 3

				dsll $t0, $t3, 16 ;Dirección X
				dadd $t5, $t5, $t0
				dsll $t0, $t4, 24 ;Dirección Y
				dadd $t5, $t5, $t0
				;Desplazamos t5 por 32 para juntar las mitades
				dsll $t5, $t5, 16
				dsll $t5, $t5, 16
				dadd $t1, $t1, $t5
				
				
				sd $t1, 0($sp)
				jr $ra
;

;PASO
;Ejecuta un paso en la pelota apuntada por $a0

;$t4 ; Coordenada X de la pelota
;$t5 ; Coordenada Y de la pelota
;$t6 ; Dirección X de la pelota
;$t7 ; Dirección Y de la pelota
;$t8 ; Color de la pelota

;Pelota = yxYXABGR en la memoria, o
;RGBAXYxy para acceder a los bytes en orden
;La dirección puede ser -1, 0 o 1, pero se guarda como 0, 1 o 2 respectivamente, así que se debe restar 1 en el código que la carge


PASO: 	ld $t0, 0($a0) ;Carga el byte
		;COLOR
		dsll $t8, $t0, 16 ;Desplazamos a la izquierda y luego a la derecha para aislar el color
		dsll $t8, $t8, 16 ;(El desplazamiento tiene un límite muy molesto de 31, por eso hay que hacerlo 2 veces)
		dsrl $t8, $t8, 16
		dsrl $t8, $t8, 16
		
		dsrl $t0, $t0, 16
		dsrl $t0, $t0, 16
		andi $t4, $t0, 0xFF ;X
		dsrl $t0, $t0, 8
		andi $t5, $t0, 0xFF ;Y
		dsrl $t0, $t0, 8
		andi $t6, $t0, 0xFF ;Dir X
		daddi $t6, $t6, -1
		dsrl $t0, $t0, 8
		andi $t7, $t0, 0xFF ;Dir Y
		daddi $t7, $t7, -1
		
		
		
		
		lwu $t2, Blanco($zero) ;Color de fondo
		daddi $t3, $0, 5 ; Comando para dibujar un punto
		;Borra la pelota
		sw $t2, 0($s7) 
		;sw $t8, 0($s7) 
		sb $t4, 5($s7)
		sb $t5, 4($s7)
		sd $t3, 0($s6)
		;Mueve la pelota en la dirección actual
		dadd $t4, $t4, $t6 
		dadd $t5, $t5, $t7
		;Comprueba que la pelota no esté en la columna de más a la derecha. Si es así, cambia la dirección en X.
		daddi $t1, $0, 48 
		slt $t0, $t1, $t4
		dsll $t0, $t0, 1
		dsub $t6, $t6, $t0
		;Comprueba que la pelota no esté en la fila de más arriba. Si es así, cambia la dirección en Y.
		slt $t0, $t1, $t5 
		dsll $t0, $t0, 1
		dsub $t7, $t7, $t0
		;Comprueba que la pelota no esté en la columna de más a la izquierda. Si es así, cambia la dirección en X.
		slti $t0, $t4, 1 
		dsll $t0, $t0, 1 
		dadd $t6, $t6, $t0
		;Comprueba que la pelota no esté en la fila de más abajo. Si es así, cambia la dirección en Y.
		slti $t0, $t5, 1 
		dsll $t0, $t0, 1
		dadd $t7, $t7, $t0
		;Dibuja la pelota.
		sw $t8, 0($s7) ;Color
		sb $t5, 4($s7) ;Y
		sb $t4, 5($s7) ;X
		sd $t3, 0($s6) ;Dibuja el punto
		
		;Ahora hay que volver a guardar el byte
		daddi $t0, $t8, 0 ;Color
		daddi $t1, $t7, 1 ;Dir Y
		dsll $t1, $t1, 8
		dadd $t1, $t6, $t1 ;Dir X
		daddi $t1, $t1, 1
		dsll $t1, $t1, 8
		dadd $t1, $t5, $t1 ;Y
		dsll $t1, $t1, 8
		dadd $t1, $t4, $t1 ;X
		dsll $t1, $t1, 16
		dsll $t1, $t1, 16
		dadd $t0, $t0, $t1
		sd $t0, 0($a0)
		
		jr $ra
;




