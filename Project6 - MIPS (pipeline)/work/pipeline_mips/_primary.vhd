library verilog;
use verilog.vl_types.all;
entity pipeline_mips is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end pipeline_mips;
