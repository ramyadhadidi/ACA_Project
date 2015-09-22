onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /multiplier__tb/sut/clk
add wave -noupdate -format Logic -radix hexadecimal /multiplier__tb/sut/start
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/a
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/b
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/s
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/A
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/P
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/ai
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/bi
add wave -noupdate -format Logic -radix hexadecimal /multiplier__tb/sut/ci
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/so
add wave -noupdate -format Literal -radix unsigned /multiplier__tb/sut/counter
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/adder/ai
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/adder/bi
add wave -noupdate -format Logic -radix hexadecimal /multiplier__tb/sut/adder/ci
add wave -noupdate -format Literal -radix hexadecimal /multiplier__tb/sut/adder/so
add wave -noupdate -format Logic -radix hexadecimal /multiplier__tb/sut/adder/co
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {150 ns} 0}
configure wave -namecolwidth 205
configure wave -valuecolwidth 100
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
WaveRestoreZoom {144 ns} {260 ns}
