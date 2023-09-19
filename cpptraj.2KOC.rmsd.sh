#!/bin/bash

#SBATCH --job-name=cpprmsd
#SBATCH -N 1
#SBATCH -n 20 
##SBATCH --gres=gpu:1
#SBATCH --partition=shortq7,mediumq7,longq7,shortq7-gpu,longq7-rna
##SBATCH --partition=longq7-rna
##SBATCH --mail-type=ALL
#SBATCH --time=6:00:00
##SBATCH --exclusive
##SBATCH --nodelist=nodegpu025


###################################
#load amber 18 on atlas
###################################
source /opt/ohpc/pub/apps/rnachem/amber18_gpu/amber.sh
source /opt/ohpc/pub/apps/rnachem/amber18_gpu/modules2load.txt

rm *.agr
rm *.dat

#find $SLURM_SUBMIT_DIR -maxdepth 1 -type f \( -name "slurm-*" ! -name "slurm-$SLURM_JOB_ID.out" \) -delete

cat>input<<EOF
parm ./strip.prmtop.new
trajin ./combined_md.mdcrd

symmrmsd ToFirstAll2-13 :2-13&!@H= first out rmsd1.agr mass time 0.00002 xlabel "  " 
symmrmsd ToFirstHairpin6-9 :6-9&!@H= first out rmsd1.agr mass time 0.00002 
symmrmsd ToFirstStem2-5,10-13 :2-5,10-13&!@H= first out rmsd1.agr mass time 0.00002 

symmrmsd ToFirstAll :2-13&!@H= first out rmsd1.dat mass time 0.00002
symmrmsd ToFirstHairpin :6-9&!@H= first out rmsd1.dat mass time 0.00002 
symmrmsd ToFirstStem :2-5,10-13&!@H= first out rmsd1.dat mass time 0.00002 

go
EOF

#cpptraj -i input

mpirun -n 20 cpptraj.MPI -i input


############################

cat>input2<<EOF

parm ./strip.prmtop.new
trajin ./combined_md.mdcrd 1 1
trajout first.pdb pdb
run
EOF

cpptraj -i input2

############################

cat>input3<<EOF

parm ./strip.prmtop.new
trajin ./combined_md.mdcrd lastframe
trajout last.pdb pdb
run
EOF


cpptraj -i input3




