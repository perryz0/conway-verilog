onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /grid_testbench/clk
add wave -noupdate /grid_testbench/reset
add wave -noupdate /grid_testbench/row_select
add wave -noupdate /grid_testbench/col_select
add wave -noupdate /grid_testbench/set_initial
add wave -noupdate /grid_testbench/new_state
add wave -noupdate /grid_testbench/enable_update
add wave -noupdate /grid_testbench/grid
add wave -noupdate /grid_testbench/grid_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1 ns}
