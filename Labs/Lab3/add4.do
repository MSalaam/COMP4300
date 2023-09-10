add wave -position insertpoint \
  sim:/add4/propagation \
  sim:/add4/input \
  sim:/add4/clock \
  sim:/add4/output 

force -freeze sim:/add4/clock 0 0
run
force -freeze sim:/add4/clock 1 0
run
run
force -freeze sim:/add4/input 32'h00000100 0
run
run
force -freeze sim:/add4/input 32'h00000004 0
run
force -freeze sim:/add4/clock 0 0
run
force -freeze sim:/add4/clock 1 0
run
force -freeze sim:/add4/input 32'h99999999 0
run
force -freeze sim:/add4/clock 0 0
run
force -freeze sim:/add4/clock 1 0
run
force -freeze sim:/add4/input 32'hFFFFFFFF 0
force -freeze sim:/add4/clock 0 0
run
force -freeze sim:/add4/clock 0 0
force -freeze sim:/add4/clock 1 0
run