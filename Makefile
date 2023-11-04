vcs_files := dut.v

VCS_COMPILE_OPTS := +v2k -sverilog -debug_access+pp -timescale=1ps/1ps -full64
VCS_COMPILE_OPTS += -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed
VCS_COMPILE_OPTS += -ntb_opts uvm-1.1 +error+200
VCS_COMPILE_OPTS += +nospecify +notimingcheck

VCS_RUN_OPTS := +UVM_TEST_NAME=my_case0
#VCS_RUN_OPTS := +UVM_TEST_NAME=base_test

LOG_COMPILE_OPTS = | tee compile.log
LOG_RUN_OPTS = | tee tun.log

all: clean comp run

comp:
	@echo ">> Compiling testbench in VCS"
	vcs $(VCS_COMPILE_OPTS) $(vcs_files) $(LOG_COMPILE_OPTS)
run:
	echo ">> Running testbench in VCS"
	./simv $(VCS_RUN_OPTS) $(LOG_RUN_OPTS)

clean:
	rm -f simv
	rm -rf csrc simv.daidir
	rm -f compile.log run.log

fsdb:
	verdi -sv -ssy -ssv -ssz $(VCS_COMPILE_OPTS) -ssf novas.fsdb &
