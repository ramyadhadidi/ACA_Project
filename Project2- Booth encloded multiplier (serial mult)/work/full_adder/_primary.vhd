library verilog;
use verilog.vl_types.all;
entity full_adder is
    port(
        ai              : in     vl_logic_vector(33 downto 0);
        bi              : in     vl_logic_vector(33 downto 0);
        ci              : in     vl_logic;
        so              : out    vl_logic_vector(33 downto 0);
        co              : out    vl_logic
    );
end full_adder;
