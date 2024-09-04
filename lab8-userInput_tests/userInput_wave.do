onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /userInput_testbench/clk
add wave -noupdate /userInput_testbench/reset
add wave -noupdate /userInput_testbench/KEY
add wave -noupdate /userInput_testbench/SW0
add wave -noupdate /userInput_testbench/row_select
add wave -noupdate /userInput_testbench/col_select
add wave -noupdate /userInput_testbench/set_initial
add wave -noupdate /userInput_testbench/cell_state
add wave -noupdate /userInput_testbench/GrnPixels
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {863 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1208 ps}
