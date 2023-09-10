
add wave -position insertpoint \
sim:/mux/input_1 \
sim:/mux/input_0 \
sim:/mux/which \
sim:/mux/output

force -freeze sim:/mux/input_1 32'h00000001 0
run
force -freeze sim:/mux/which 1 0
run
force -freeze sim:/mux/input_0 32'h00000110 0
run
force -freeze sim:/mux/which 0 0
run