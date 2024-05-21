_init:
    addi x1, x0, 2000
    addi x5, x0, 60 /*number of frames * width of int*/
restart:
    add x6, x0, x0
new_frame:
    lw x7, 0(x6)
    sw x7, 0x400(x0)
    
take_time:
    add x2, x0, x0
loop:
    nop
    add x3, x0, x0
    addi x2, x2, 1
    beq x2, x1, end  /*return!*/
loop2:
    nop
    nop
    nop
    nop
    addi x3, x3, 1
    beq x3, x1, loop
    beq x0, x0, loop2    
end:

    addi x6, x6, 4
    ble x6, x5, new_frame /* do one more frame */
    beq x0, x0, restart