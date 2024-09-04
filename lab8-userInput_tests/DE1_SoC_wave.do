onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_testbench/CLOCK_50
add wave -noupdate -label {HEX0 (victory)} /DE1_SoC_testbench/HEX0
add wave -noupdate -label {LEDR (Playfield)} /DE1_SoC_testbench/LEDR
add wave -noupdate -label {KEY[3] (P2 left)} {/DE1_SoC_testbench/KEY[3]}
add wave -noupdate -label {KEY[0] (P1 right)} {/DE1_SoC_testbench/KEY[0]}
add wave -noupdate -label {SW[9] (reset)} {/DE1_SoC_testbench/SW[9]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {582 ps} 0}
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
WaveRestoreZoom {0 ps} {4096 ps}
