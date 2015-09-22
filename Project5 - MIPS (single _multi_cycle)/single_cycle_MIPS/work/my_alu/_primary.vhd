library verilog;
use verilog.vl_types.all;
entity my_alu is
    port(
        aluA            : in     vl_logic_vector(31 downto 0);
        aluB            : in     vl_logic_vector(31 downto 0);
        aluOp           : in     vl_logic_vector(3 downto 0);
        aluResult       : out    vl_logic_vector(31 downto 0);
        ALUZero         : out    vl_logic
    );
end my_alu;
