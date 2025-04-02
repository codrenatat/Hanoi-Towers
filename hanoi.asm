.data        
.text         

main:
    addi s0, zero, 3        # s0 = 3 -> Número de discos a mover
    addi t0, zero, 32       # t0 = 32 -> Tamaño de cada disco
    addi t1, zero, 0        # t1 = 0 -> Acumulador para el cálculo del total de memoria necesaria
    addi t2, zero, 0        # t2 = 0 -> Contador para bucle

calcularTorres:             # Calcular el espacio requerido por los discos
    add t1, t1, t0          # Acumula 32 por cada disco ? t1 = t1 + 32
    addi t2, t2, 1          # t2 = t2 + 1
    bne t2, s0, calcularTorres # Si aún no se ha contado todos los discos, repite

    add t0, zero, t1        # Guarda el total acumulado en t0
    add t1, zero, zero      # Reinicia t1 = 0
    add t2, zero, zero      # Reinicia t2 = 0

    lui s1, 0x10010         # Dirección base de la torre A
    addi s2, s1, 4          # Torre B = torre A + 4
    addi s3, s1, 8          # Torre C = torre A + 8

    add s2, s2, t0          # Ajusta torre B para que apunte a la parte superior
    add s3, s3, t0          # Ajusta torre C para que apunte a la parte superior

for:                        # Colocar los discos inicialmente en la torre A
    blt t1, s0, discos      # Si t1 < número de discos, entra a discos
    lui s1, 0x10010         # Reinicia torre A para función hanoi
    jal hanoi               # Llama a la función recursiva hanoi
    jal end                 # Termina el programa

hanoi:                      # Función recursiva Hanoi
    addi t1, zero, 1        # t1 = 1, usado para comparar el caso base
    beq s0, t1, baseCase    # Si s0 == 1, ir a caso base

    addi sp, sp, -20        # Reserva espacio en el stack para guardar 5 registros
    sw ra, 0(sp)            # Guarda dirección de retorno
    sw s0, 4(sp)            # Guarda número de discos
    sw s1, 8(sp)            # Guarda puntero torre A
    sw s2, 12(sp)           # Guarda puntero torre B
    sw s3, 16(sp)           # Guarda puntero torre C

    addi s0, s0, -1         # Decrementa el número de discos (N - 1)

    add t2, s2, zero        # Copia torre B a t2
    add s2, s3, zero        # Torre B = torre C
    add s3, t2, zero        # Torre C = torre original B (swap torres para siguiente llamada recursiva)

    jal hanoi              # Llama recursivamente hanoi con N - 1 discos

    lw s0, 4(sp)            # Restaura número de discos
    lw s1, 8(sp)            # Restaura puntero torre A
    lw s2, 12(sp)           # Restaura puntero torre B
    lw s3, 16(sp)           # Restaura puntero torre C

    addi s1, s1, -32        # Apunta a la posición del disco más grande en torre A
    sw zero, 0(s1)          # Elimina el disco de torre A

    addi s3, s3, -32        # Prepara espacio en torre C para colocar el disco
    sw s0, 0(s3)            # Coloca el disco en la torre C

    addi s0, s0, -1         # Disminuye el número de discos para la llamada recursiva siguiente

    add t2, s1, zero        # t2 = torre A
    add s1, s2, zero        # torre A = torre B
    add s2, t2, zero        # torre B = torre A anterior (swap)

    jal hanoi              # Segunda llamada recursiva

    lw ra, 0(sp)            # Restaura dirección de retorno
    addi sp, sp, 20         # Libera espacio del stack

    jalr ra                 # Retorna de la función

baseCase:                   # Caso base: solo hay un disco por mover
    addi s1, s1, -32        # Prepara dirección de disco a quitar de torre A
    sw zero, 0(s1)          # Elimina el disco de torre A

    addi s3, s3, -032       # Prepara espacio en torre C
    sw s0, 0(s3)            # Coloca el disco

    jalr ra                 # Retorna

discos:                     # Coloca los discos en torre A desde el más grande al más pequeño
    addi t1, t1, 1          # Incrementa contador de discos
    sw t1, 0(s1)            # Guarda disco en memoria
    addi s1, s1, 32         # Avanza al siguiente espacio para el disco
    jal for                 # Repite el bucle para el siguiente disco

end:
    nop                     # Fin del programa
                                	
    	                       
    	                                              
    	                                                                     
    	                                                                                            
    	                                                                                                                                          
    	                 
	
