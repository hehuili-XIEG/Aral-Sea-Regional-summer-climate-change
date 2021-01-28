#!/bin/bash
#PBS -S /bin/bash
#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=24:mpiprocs=24
#PBS -o /home/heheuili/log_file/50.{startdate}.log
#PBS -N 90.{startdate}
#
#

set -x

STARTDATE={startdate}
STOPDATE={stopdate}


RUNSTART=00
NPROC=$NCPUS
TSTEP=450.
RUNLENGTH=48
DAYINCREMENT={interval}

REMOTE=gloin

#COUPLING=/mnt/HDS_CLIMATE/CLIMATE/CASIA
COUPLING=/mnt/HDS_CLIMATE_LBC/CLIMATE_LBC/LBC_CORDEX_CA50

EXP=CA12

ERADIR=$HOME/CY36-script

NAM001=$ERADIR/namelist/name.fc36.ALR.12.cp2

NAMRFA=$ERADIR/namelist/nam.FAreplace.surf

CLIM_12km=/mnt/HDS_ALD_TEAM/ALD_TEAM/hamdi/CENTRAL-ASIA/clim/12km/clim_m

WORKDIR=/scratch-a/heheuili/CASIA/12km_sfx_50km
#WORKDIR=/scratch-b/alaros5/CASIA/12km_sfx_50km

#ALADIN_EXEC=/home/duchenef/aladin/pack/cy36/bin/MASTER
ALADIN_EXEC=/home/hamdi/aladin/pack/cy36.obsolete/bin/MASTER
#ENV=$ERADIR/scr/ENV_ALADIN_36
ENV=/home/daand/aladin/runs/ref38t1/ENV_ALADIN

DECDATE=$HOME/bin/decdate


#-------------------------------------------------------- coupling files --------------------------

function get_coupling
{
set -x

COUPDATE=$1
COUPRUN=$2
COUPEXP=$3

let NCOUP=10#${RUNLENGTH}/6+10#1


COUPYEAR=`echo $COUPDATE | cut -c1-4`
COUPMONTH=`echo $COUPDATE | cut -c5-6`


#++++++++++++++++++++++++ typeset -Z3 NCOUP ++++++++++++++
if [[ $NCOUP -le 9 ]]
then
NCOUP=00${NCOUP}
else
NCOUP=0${NCOUP}
fi
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CPLNR=0

RUN_DATE=$COUPDATE

let CTIME=$COUPRUN


#++++++++++++++++++++++++ typeset -Z2 CTIME ++++++++++++++
if [[ $CTIME -le 9 ]]
then
CTIME=0${CTIME}
fi
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#++++++++++++++++++++++++ typeset -Z3 CPLNR ++++++++++++++
if [[ $CPLNR -le 9 ]]
then
CPLNR=00${CPLNR}
else
CPLNR=0${CPLNR}
fi
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if [[ $COUPMONTH -le 06 ]]
then
	scp ${REMOTE}:$COUPLING/$COUPYEAR/$COUPMONTH/ERA-Int_CA50_${COUPDATE}.tar .
	tar -xf ERA-Int_CA50_${COUPDATE}.tar
else
	scp ${REMOTE}:$COUPLING/$COUPYEAR/$COUPMONTH/ERA-Int_CA50_${COUPDATE}.tar .
	tar -xf ERA-Int_CA50_${COUPDATE}.tar
fi

while [ $CPLNR != $NCOUP ]
do

   ANA_DATE=$COUPDATE
   let cTIME=10#$COUPRUN+10#$CTIME
   while [ $cTIME -ge 0024 ]
   do
     ANA_DATE=`$DECDATE ${ANA_DATE} +1`
     let cTIME=10#$cTIME-10#24
   done
   ANA_MONTH=`echo ${ANA_DATE} | cut -c5-6`

   scp $REMOTE:${CLIM_12km}${ANA_MONTH} CA12

   cp $NAMRFA fort.4

   cp BC_${COUPDATE}${COUPRUN} LBC

   /home/duchenef/bin/FAreplace_new

   mv LBC ELSCF${EXP}ALBC${CPLNR}

 
  let CPLNR=10#$CPLNR+1
#++++++++++++++++++++++++ typeset -Z3 CPLNR ++++++++++++++
  if [[ $CPLNR -le 9 ]]
  then
  CPLNR=00${CPLNR}
  else
  CPLNR=0${CPLNR}
  fi  
  

  if [ $COUPRUN == 18 ] 
  then
    rm -f BC_* 
    COUPRUN=00
    COUPDATE=`$DECDATE $COUPDATE +1`
    COUPYEAR=`echo $COUPDATE | cut -c1-4`
    COUPMONTH=`echo $COUPDATE | cut -c5-6`
	if [[ $COUPMONTH -le 06 ]]
	then
		scp ${REMOTE}:$COUPLING/$COUPYEAR/$COUPMONTH/ERA-Int_CA50_${COUPDATE}.tar .
	        tar -xf ERA-Int_CA50_${COUPDATE}.tar
	else
		scp ${REMOTE}:$COUPLING/$COUPYEAR/$COUPMONTH/ERA-Int_CA50_${COUPDATE}.tar .
           	tar -xf ERA-Int_CA50_${COUPDATE}.tar
	fi
    else
    let COUPRUN=10#$COUPRUN+6

#++++++++++++++++++++++++ typeset -Z2 COUPRUN ++++++++++++++
    if [[ $COUPRUN -le 9 ]]
     then
     COUPRUN=0${COUPRUN}
    fi


  fi

done
rm -f BC*

}

#++++++++++++++++++++++++++++++++++++++++++++++++++ Forecast +++++++++++++++++++++++++++++

DATE={startdate}

. $ENV


YYYY=`echo $DATE | cut -c1-4`
MM=`echo $DATE | cut -c5-6`
DD=`echo $DATE | cut -c7-8`



if [[ ! -d $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART ]]
then
mkdir -p $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART
fi

rm -f $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART/*
cd $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART


pwd 
ls



### first we get the coupling files from the archive
 
 get_coupling $DATE ${RUNSTART} $EXP



### and now we actually run ALADIN:fc_12km_sfx.sh
  echo 'echo MONITOR: $* >&2' >monitor.needs
  chmod +x monitor.needs

  ln -sf ELSCF${EXP}ALBC000 ICMSH${EXP}INIT

  cat $NAM001  | grep -v '^!' | sed  -e "s/!.*//" \
                                   -e "s/{cnmexp}/$EXP/" \
                                   -e "s/{neini}/0/" \
                                   -e "s/{lsprt}/.T./" \
                                   -e "s/{cfpath}/ICMSH/" \
                                   -e "s/{yyyymmdd}/${YYYY}${MM}${DD}/" \
                                   -e "s/{sssss}/$(( ${RUNSTART}*3600 ))"/ \
                                   -e "s/{nproc}/${NPROC}/" > fort.4  

  
  ln -s ${ALADIN_EXEC} ALADIN
  ls -al
  #mpirun -np ${NPROC} ALADIN -e$EXP -vmeteo -c001 -maladin -t$TSTEP -fh${RUNLENGTH}
  mpiexec_mpt -np ${NPROC} ./ALADIN -e$EXP -vmeteo -c001 -maladin -t$TSTEP -fh${RUNLENGTH} > log.out 2>log.err

##### 4km run

ksh $ERADIR/scr/FS/kick_199095_70s_SST $DATE $DATE $DAYINCREMENT 

### remove all results of 50km
###rm -rf $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART/*
rm $WORKDIR/$YYYY/$MM/$DD/r00/drhook.prof.* 
rm $WORKDIR/$YYYY/$MM/$DD/r00/ERA-Int_CA50_*.tar

NEXTDATE=`/home/duchenef/bin/decdate $DATE +$DAYINCREMENT`

if [ $NEXTDATE -le $STOPDATE ] 
  then
   ksh $ERADIR/scr/FS/kick_199095_ERA $NEXTDATE $STOPDATE $DAYINCREMENT
  fi 

cd $WORKDIR
#rm -rf $WORKDIR
#rm ERA-*.tar


 


