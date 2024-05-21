package RISCV;
    typedef enum bit[4:0] 
    {
        LOAD   = 5'b00000,
        STORE  = 5'b01000,
        BRANCH = 5'b11000,
        OP_IMM = 5'b00100,
        OP     = 5'b01100,
        SYSTEM = 5'b11100,
        JAL    = 5'b11011,
        JALR   = 5'b11001,
        LUI    = 5'b01101,
        AUIPC  = 5'b00101
    } op_type;
    
    typedef enum bit[3:0]
    {
        ADD = 4'b0010,
        SUB = 4'b0110,
        AND = 4'b0000,
        OR  = 4'b0001,
        XOR = 4'b0011,
        SLL = 4'b1000,
        SRL = 4'b1010,
        SRA = 4'b1011,
        NOP = 4'b1111
        
        // TODO: multiply extension here
    } alu_func_t;
 
endpackage