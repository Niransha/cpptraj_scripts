#!/bin/bash

cdir=`pwd`
edir=$(dirname "0") # executing directry

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

for folder in $(find . -maxdepth 1 -mindepth 1 -type d \( -name "AAAA" -o -name "UUUU" -o -name "2KOC*" \) );
do
cd $folder

echo $folder "#################"
folname=`basename $folder` 

mkdir combine
cd combine

#:<<'AAA'
rm combined_md.mdcrd slurm* *.pdb

        # combine all
jb1=$(sbatch $SCRIPTPATH/cpptraj.combine_md_all.sh)   # run combine
id1=`echo $jb1 | awk '{print $4}'`


cp $SCRIPTPATH/cpptraj_rmsd_scripts/cpptraj.AAAA.rmsd.sh ./


        #rmsd with respect to fist frame
jobsub=$(sbatch --dependency=afterany:$id1 cpptraj.AAAA.rmsd.sh)  # rmsd calc uniq in each folders
id2=`echo $jobsub | awk '{print $4}'`

echo " second job $id2 depends on $id1 #####"

#AAA

#ls -lthr *.mdcrd
cd ../

cd ../ # AAAA
done





