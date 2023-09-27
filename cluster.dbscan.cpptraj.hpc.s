#!/bin/bash

#SBATCH -J clsdb
##SBATCH -N 1
#SBATCH -n 20
#SBATCH -p longq7
##SBATCH --mail-type=ALL
##SBATCH --nodelist=nodeamd002
#SBATCH --mem=70G
##SBATCH --exclusive
##SBATCH --exclude=nodegpu[021-025]

###################################
#load amber 18 on atlas
###################################
source /opt/ohpc/pub/apps/rnachem/amber18_gpu/amber.sh
source /opt/ohpc/pub/apps/rnachem/amber18_gpu/modules2load.txt


cat>input<<EOF
parm ./strip.prmtop.new
trajin ./combined_md.mdcrd

cluster C0 \
dbscan minpoints 25 epsilon 1.2 sievetoframe \
rms :1-14&!@H= \
sieve 5 random \
singlerepout traj singlerepfmt netcdf \
clusterout clust_traj clusterfmt netcdf \
repout rep repfmt pdb \
avgout Avg avgfmt pdb \
info info.dat \
out cnumvtime.dat \
sil Sil \
summary summary.dat \
cpopvtime cpopvtime.agr normframe 
go
EOF

#cpptraj -i input
mpirun -n 20 cpptraj.MPI -i input






