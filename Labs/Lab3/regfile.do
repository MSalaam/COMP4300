add wave -position insertpoint \
sim:/regfile/read_notwrite \
sim:/regfile/clock \
sim:/regfile/regA \
sim:/regfile/rebB \
sim:/regfile/data_in \
sim:/regfile/dataA_out \
sim:/regfile/dataB_out \
sim:/regfile/arr2(3) \
sim:/regfile/arr2(10)

run 
force -freeze sim:/regfile/regA 5'h0A 0
force -freeze sim:/regfile/rebB 5'h0B 0
force -freeze sim:/regfile/data_in 32'h11111111 0
run 
force -freeze sim:/regfile/clock 1 0
run 
force -freeze sim:/regfile/regA 5'h03 0
force -freeze sim:/regfile/data_in 32'h22222222 0
run 
force -freeze sim:/regfile/read_notwrite 1
run 
force -freeze sim:/regfile/regA 5'h0F 0
force -freeze sim:/regfile/rebB 5'h0A 0
run 