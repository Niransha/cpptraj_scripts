#!/bin/bash
#SBATCH --job-name=cpptraj
#SBATCH -N 1
#SBATCH -n 40
##SBATCH --gres=gpu:1
#SBATCH --partition=shortq7,mediumq7,longq7,shortq7-gpu,longq7-rna
##SBATCH --partition=longq7-rna
##SBATCH --mail-type=ALL
#SBATCH --time=6:00:00
##SBATCH --exclusive
##SBATCH --nodelist=nodegpu025

#get last md_i.mdcrd get i
last=`ls -l ../md_*.mdcrd | awk '{split($9,a,"/"); split(a[2],b,"_"); split(b[2],c,"."); print c[1] }' | sort -nk1 | tail -1`

###################################
#load amber 18 on atlas
###################################
#source /opt/ohpc/pub/apps/rnachem/amber18_gpu/amber.sh
#source /opt/ohpc/pub/apps/rnachem/amber18_gpu/modules2load.txt
source /mnt/rna/home/programs/amber22/amber.sh


#trajin ../md_\$i.mdcrd 0 last 100  $skip every 100,  

cat>input_combine<<EOF
parm ../prmtop.new

for i=1;i<$(($last+1));i++
   trajin ../md_\$i.mdcrd 0 last 

done

autoimage
strip :Cl-
strip :Na+
strip :WAT outprefix strip
trajout combined_md.mdcrd netcdf
go
EOF

#image center familiar

mpirun -n 40 cpptraj.MPI -i input_combine



