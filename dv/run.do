if [file exists "work"] {vdel -all}
vlib work

# Use unique transcript file per run (with full path)
transcript file "test_transcript.log"

vlog -f rtl.f +cover -covercells
vlog -f tb.f +cover -covercells
vopt apb_tb_top -o top_optimized +acc +cover=bcefsx
#+ahb_lite(rtl)

set test_names {apb_base_test}

foreach test_name $test_names {
	vsim top_optimized -cover -voptargs=+acc -solvefaildebug=2 -debugDB +UVM_TESTNAME=$test_name

	set NoQuitOnFinish 1
	onbreak {resume}
	log /* -r
	#run -all
	#coverage report -assert -details -zeros -verbose -output reports/assertion_based_coverage_report.txt -append /.
	#coverage report -detail -cvg -directive -comments -option -memory -output reports/functional_coverage_report.txt {}

	#coverage attribute -name TESTNAME -value $test_name
	#coverage save reports/$test_name.ucdb

}

# Close transcript
#transcript file ""

#vcover merge reports/reg_test.ucdb

#quit -sim

#vcover report -output reports/APB_Coverge_report.txt reports/AHB_lite_tb.ucdb -zeros -details -annotate -all