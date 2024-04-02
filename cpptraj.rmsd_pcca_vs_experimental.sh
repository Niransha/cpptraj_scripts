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


source /mnt/rna/home/programs/amber22/amber.sh
#source /mnt/rna/home/programs/amber22/amber22_athene.sh
rm *.agr
rm *.dat

find $SLURM_SUBMIT_DIR -maxdepth 1 -type f \( -name "slurm-*" ! -name "slurm-$SLURM_JOB_ID.out" \) -delete

cat>input<<EOF
parm ../top.prmtop 
reference ../Analysis/ambGGCCadded.pdb

for i=1;i<51;i++
clear trajin    
   trajin  ./pcca_\$i_50samples.pdb     

symmrmsd \$i_ToExpHairpin4-7 :4-7&!@H= :4-7&!@H= reference out rmsd1.agr mass xlabel "molecule number " 
symmrmsd \$i_ToExpHairpin :4-7&!@H= :4-7&!@H= reference out rmsd1.dat mass xlabel "acv "
  
done

go
EOF

#cpptraj -i input
cpptraj -i input

