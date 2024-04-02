#perfom cpprmsd frist and then get rmsd1.dat file frame vs rmsd then do follwing
# check the time vs rmsd file and make histogram andnormalize it using xmgrace
#xmgrace rmsd1.dat file > data > trasnformation > Histogram > tick normalize start=0 , stop=max, #of bins=max*100 so you get bins of 0.01

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



max=4.15
clusname=c1

awk -v max=$max '{if($2>=(max-0.1) && $2<=(max+0.1)) printf($1",")}' rmsd1.dat > c1.dat

cat> cpp_extract_selected_frames.in<EOF
parm strip.prmtop.new
trajin combined_md.mdcrd 1 last 1
autoimage
rms fit :1-4
# exract only selected frames from
trajout $clusname.mdcrd netcdf onlyframes $(cat c1.dat) \n
run
exit
go
EOF

cpptraj -i cpp_extract_selected_frames.in

sleep 10
echo "########################## $clusname.mdcrd created  ############ "
########## take average of each cx cluster ##################

cat>input_avg<<EOF

parm strip.prmtop.new
trajin $clusname.mdcrd 
average test.pdb pdb 
run

EOF


cpptraj -i input_avg


