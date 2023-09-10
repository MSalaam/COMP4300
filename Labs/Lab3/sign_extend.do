add wave -position end
sim:/sign_extend/input
sim:/sign_extend/output

force -freeze sim:/sign_extend/input 16'h1000 0
run
force -freeze sim:/sign_extend/input 16'h0111 0
run
force -freeze sim:/sign_extend/input 16'h1111 0
run