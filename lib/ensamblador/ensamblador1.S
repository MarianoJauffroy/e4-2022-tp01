/**
 * Referencias importantes:
 * https://developer.arm.com/documentation/dui0552/a
 * https://github.com/ARM-software/abi-aa/tree/main/aapcs32
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre: 
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm

defun copiaMemoria
    // Implementación aquí
    // R0: origen, R1: destino, R2: longitud
    
0:
     tst R2, #(-1)
     beq fin0
    ldrb R3, [R0],#1 // guardo en el registro un byte de la memoria 
    strb R3, [R1],#1 // post incremento al proximo byte y lo cargo en R1
    subs R2,R2,#1 
    bne 0b // Cuando esta resta sea igual a 0 sera pq ya  se recorrio toda la memoria entonces se termina el programa
fin0:
    bx lr
endfun copiaMemoria

defun copiaCadena
    // Implementación aquí
    // R0: origen, R1: destino, R2: longitudMaxima
    //R4 longitud de cadena de trabajo
    push {R4,LR} 
    mov R4 , #0x01 // R4 sera la longitud de mi cadena de trabajo, le asigno el valor 0x01
0:
   tst R2, #(-1)
     beq 1f //reviso q R2 no sea cero y si es cero pasa a la etiqueta 1
    
    ldrb R3,[R0],#1 //copio en r3 un byte y luego postincremento para no copiar el mismo byte sucesivamente
    
    cmp R3 , #0x00
    
    beq 1f
   
    cmp R4, R2 //comparo R4 con R2 para ver si ya recorri toda la memoria 
    
    beq 0b // si son iguales, significa que ya recorri toda la memoria por lo que salto a la etiqueta 0 
    
    strb R3,[R1],#1 //escribo R3 en [R1] y luego postincremento para escribir el siguiente caracter en [R1]
    
    add R4,R4,#1 
   
    b 0b
1:
    mov R3, #0x00 //copio a r3 como ultimo caracter el valor del terminador nulo
    strb R3, [R1] //copio el terminador nulo al final de la cadena guardada en [r1]
    pop {R4,PC} //recupero R4 y PC q pushee al principio del programa
    bx lr
endfun copiaCadena

defun mayusculaEnLugar
    // Implementación aquí
    // R0: cadena, R1: longitudMaxima
     push {R1, LR}
   
    cbz R1, final

main:
    ldrb R2, [R0], #1
   
    cmp R2, #0x00 
   
    beq final // si son iguales salto a etiqueta "final"
    // ahora chequeo si la letra esta en el rango de trabajo de este programa
    cmp R2, #97 
   
    blt contador //salto a etiqueta contador
   
    cmp R2, #122 //preguntar si asi o 0x7A, chequeo si codigo ascii es mayor que mayusculas
  
    bgt contador

    sub R2, #32 // realizo el pasaje de mM a M 
    sub R0, #1
    strb R2, [R0], #1 // grabo 

contador:
    subs R1, #1
    beq final //si la longitud llega a cero, finaliza el programa
    bl main

final:
    pop {R1, PC} // recupero r1 y pc q habia pusheado al principio
   
    bx lr
endfun mayusculaEnLugar

defun minusculaEnLugar
    // Implementación aquí
    // R0: cadena, R1: longitudMaxima
 push {R1, LR}
    
    cbz R1, final2

main2:
    ldrb R2, [R0], #1
    
    cmp R2, #0x00
    
    beq final2
    // ahora chequeo si la letra esta en el rango de trabajo de este programa
    cmp R2, #65 
    
    blt contador2 //salto a contador
    
    cmp R2, #90 
    
    bgt contador2

    
    add R2, #32 // realizo el pasaje de M a m 
    
    sub R0, #1
    
    strb R2, [R0], #1 // grabo

contador2:
    
    subs R1, #1
    
    beq final2 //si la longitud llega a cero Rl programa termina
    
    bl main2

final2:
   
    pop {R1, PC}

    bx lr
endfun minusculaEnLugar