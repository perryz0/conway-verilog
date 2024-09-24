onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/clk
add wave -noupdate -label {SW[9] (reset)} {/DE1_SoC_testbench/SW[9]}
add wave -noupdate /DE1_SoC_testbench/reset
add wave -noupdate -label {SW[8] (start)} {/DE1_SoC_testbench/SW[8]}
add wave -noupdate /DE1_SoC_testbench/start_game
add wave -noupdate -label {SW[0] (color switch)} {/DE1_SoC_testbench/SW[0]}
add wave -noupdate -label {SW0 (color switch)} /DE1_SoC_testbench/SW0
add wave -noupdate /DE1_SoC_testbench/GPIO_1
add wave -noupdate /DE1_SoC_testbench/set_initial
add wave -noupdate /DE1_SoC_testbench/cell_state
add wave -noupdate /DE1_SoC_testbench/row_select
add wave -noupdate /DE1_SoC_testbench/col_select
add wave -noupdate -label {KEY[3] (left)} {/DE1_SoC_testbench/KEY[3]}
add wave -noupdate -label {KEY[2] (up)} {/DE1_SoC_testbench/KEY[2]}
add wave -noupdate -label {KEY[1] (down)} {/DE1_SoC_testbench/KEY[1]}
add wave -noupdate -label {KEY[0] (right)} {/DE1_SoC_testbench/KEY[0]}
add wave -noupdate /DE1_SoC_testbench/pattern_count
add wave -noupdate /DE1_SoC_testbench/dut/RedPixels
add wave -noupdate /DE1_SoC_testbench/dut/GrnPixels
add wave -noupdate /DE1_SoC_testbench/dut/RedPixels_next
add wave -noupdate /DE1_SoC_testbench/dut/grid_inst/grid
add wave -noupdate /DE1_SoC_testbench/dut/game_of_life/grid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15071 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {14846 ps} {17903 ps}
