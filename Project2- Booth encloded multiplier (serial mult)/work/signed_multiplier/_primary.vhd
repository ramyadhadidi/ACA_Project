library verilog;
use verilog.vl_types.all;
entity signed_multiplier is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        s               : out    vl_logic_vector(63 downto 0)
    );
end signed_multiplier;
