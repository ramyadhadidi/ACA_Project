library verilog;
use verilog.vl_types.all;
entity addsub_27bit is
    port(
        addsub          : in     vl_logic;
        a               : in     vl_logic_vector(26 downto 0);
        b               : in     vl_logic_vector(26 downto 0);
        s               : out    vl_logic_vector(26 downto 0);
        c               : out    vl_logic
    );
end addsub_27bit;
