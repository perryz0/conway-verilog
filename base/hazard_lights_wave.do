onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hazard_lights_testbench/CLOCK_PERIOD
add wave -noupdate /hazard_lights_testbench/clk
add wave -noupdate /hazard_lights_testbench/reset
add wave -noupdate /hazard_lights_testbench/SW
add wave -noupdate -expand /hazard_lights_testbench/LEDR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {650 ps} 0}
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
WaveRestoreZoom {400 ps} {1400 ps}
