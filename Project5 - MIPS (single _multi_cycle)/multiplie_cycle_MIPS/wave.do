onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/clk
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/reset
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/CS
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/NS
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/pc
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/inst
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/IR
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/PCsrc
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/rel_add_e
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/REGdst
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/SENZE
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/MemtoReg
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/WRTMem
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/WRTrf
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/WRTPC
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/WRTMAR
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/WRTIR
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/srcsel
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/ALUzero
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALUop
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/WR_line
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/WD_line
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/RD1
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/RD2
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/MAR
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/PC_line
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/src_line
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/ALUAsel
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALUBsel
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/aluA_line
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/aluB_line
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/aluResult
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/OP
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU_OP
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/mem/clk
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/mem/write
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/mem/address
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/mem/write_data
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/mem/read_data
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/rf/clk
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/rf/write
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/rf/WR
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/rf/WD
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/rf/RR1
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/rf/RR2
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/rf/RD1
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/rf/RD2
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/aluA
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/aluB
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/aluOp
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/aluResult
add wave -noupdate -format Logic -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/ALUZero
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/aluAs
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/aluBs
add wave -noupdate -format Literal -radix hexadecimal /multi_cycle_mips__tb/uut/ALU/results
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {66 ns} 0}
configure wave -namecolwidth 239
configure wave -valuecolwidth 84
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2 ns} {114 ns}
