library verilog;
use verilog.vl_types.all;
entity single_cycle_mips is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end single_cycle_mips;
