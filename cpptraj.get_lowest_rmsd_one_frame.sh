#!/bin/bash
#run this script using folder_go_in.sh script 
source /mnt/rna/home/programs/amber22/amber.sh

# GREP LOWET RMSD FRAME from file ../../scripts/lowest_sys_rmsd.txt 
#here it will get frame by reading ../../scripts/lowest_sys_rmsd.txt | t
frame=`cat ../../scripts/lowest_sys_rmsd.txt | grep $folname | awk '{print $2}'`

cat>input<<EOF
clear all
parm ../top.prmtop 
trajin ../comb_1.netcdf $(echo $frame) $(echo $frame)
trajout lowest_rmsd_$(echo $folname).pdb pdb


go
EOF

cpptraj -i input


echo "DONE #############################" 



