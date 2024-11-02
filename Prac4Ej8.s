.code
daddi r1, r0, 8
daddi r2, r0, 8
daddi r3, r1, 0
daddi r4, r0, 0
loop: daddi r3, r3, -1
bnez r3, loop
dadd r4, r4, r2
halt

