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


find $SLURM_SUBMIT_DIR -maxdepth 1 -type f \( -name "slurm-*" ! -name "slurm-$SLURM_JOB_ID.out" \) -delete

cat>input<<EOF
parm ./strip.prmtop.new
trajin ./combined_md.mdcrd 1 last 1

multidihedral AllTorsions1 chin resrange 1-4 out AllChiTorsions1.dat range360 time 0.00002 xlabel "  "
multidihedral AllTorsions2 chin resrange 1-4 out AllChiTorsionsNo360.dat time 0.00002 xlabel "  " 

run

go
EOF

#cpptraj -i input

mpirun cpptraj.MPI -i input


#mpirun -n 20 cpptraj.MPI -i input



