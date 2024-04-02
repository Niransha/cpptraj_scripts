## will give you seperate rmsd.dat for each file  ./pcca_"$i"_50samples.pdb 

#!/bin/bash
#SBATCH --job-name=cpprmsd
#SBATCH -N 1
#SBATCH -n 20 
##SBATCH --gres=gpu:1
##SBATCH --partition=shortq7,mediumq7,longq7,shortq7-gpu,longq7-rna
#SBATCH --partition=longq7-rna
##SBATCH --mail-type=ALL
##SBATCH --time=6:00:00
##SBATCH --exclusive
##SBATCH --nodelist=nodegpu025

source /mnt/rna/home/programs/amber22/amber22_athene.sh

rm *.agr
rm *.dat

find $SLURM_SUBMIT_DIR -maxdepth 1 -type f \( -name "slurm-*" ! -name "slurm-$SLURM_JOB_ID.out" \) -delete


for i in {1..3}
do
cat>input<<EOF
clear all
parm ../top.prmtop 
reference ../Analysis/ambGGCCadded.pdb

trajin  ./pcca_"$i"_50samples.pdb       

#symmrmsd ToExpHairpin4-7 :4-7&!@H= :4-7&!@H= reference out rmsd1.agr mass xlabel "molecule number " 
symmrmsd ToExpHairpin :4-7&!@H= :4-7&!@H= reference out rmsd_$i.dat mass xlabel "acv "

go
EOF

cpptraj -i input

done













