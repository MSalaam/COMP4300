add wave -position insertpoint \
sim:/dlx_register/in_val \
sim:/dlx_register/clock \
sim:/dlx_register/out_val

force -freeze sim:/dlx_register/in_val 32'h00000001 0
run
force -freeze sim:/dlx_register/clock 1 0
run
force -freeze sim:/dlx_register/in_val 32'h00000003 0
run
force -freeze sim:/dlx_register/in_val 32'h00000009 0
run
force -freeze sim:/dlx_register/clock 0 0
force -freeze sim:/dlx_register/in_val 32'h00000004 0
run
