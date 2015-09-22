library verilog;
use verilog.vl_types.all;
entity multi_cycle_mips is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end multi_cycle_mips;
