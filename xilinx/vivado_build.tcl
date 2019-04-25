# Build template customised for PROJ

#set common_files {}

create_project -force -part PROJPART PROJNAME

# Common files
#add_files $common_files

# Project specific files
add_files [list PROJFILES]
set_property top top [current_fileset]
add_files PROJNAME.xdc
#add_files -fileset sim_1 tb_top.vhd
#add_files -fileset sim_1 tb_top_behav.wcfg
if [file exists extra.tcl] {
    source extra.tcl
}

# Synth
reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1

launch_runs impl_1 -jobs 4 -to_step route_design
wait_on_run impl_1
set directory [get_property DIRECTORY [get_runs impl_1]]
open_checkpoint $directory/top_routed.dcp
write_bitstream -force -bin_file PROJNAME.bin.bit
write_bitstream -force PROJNAME.bit
write_debug_probes -force PROJNAME.ltx
exit

