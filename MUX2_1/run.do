# QuestaSim script: in the Transcript, cd to this folder and type:  do run.do
if {[file exists work]} { vdel -lib work -all }
vlib work
vlog Mux_2to1.v tb_Mux_2to1.v
vsim -voptargs=+acc work.tb_Mux_2to1
add wave -radix hex /tb_Mux_2to1/S /tb_Mux_2to1/A /tb_Mux_2to1/B /tb_Mux_2to1/Z
run -all
wave zoom full
