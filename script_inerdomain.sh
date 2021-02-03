#!/bin/bash
#PBS -S /bin/bash
#PBS -l walltime=02:00:00
#PBS -l select=1:ncpus=24:mpiprocs=24
#PBS -o /home/heheuili/CY36-script/scr/FS/FS.{startdate}.log
#PBS -N LC5.{startdate}


set -x

STARTDATE={startdate}
STOPDATE={stopdate}
RUNSTART_04km=12
RUNSTART_40km=00

NPROC=$NCPUS

TSTEP=180.
RUNLENGTH_04km=36



DAYINCREMENT={interval}

ERADIR=$HOME
#COUPLING=/scratch-a/alaros5/CASIA/12km
COUPLING=/scratch-a/heheuili/CASIA/4km_sfx_50km
REMOTE=gloin
SAVEDIR=/mnt/HDS_ALD_TEAM/ALD_TEAM/peng/new_ecoclimap_4km
#ARCHIVE=/mnt/HDS_ALD_TEAM/ALD_TEAM/peng/new_ecoclimap_4km
EXP=XIN4


NAM927=$ERADIR/namelist/name.pre36.ALR4.AralSea.B
NAM927_SFX=$ERADIR/namelist/name.pre36.surfex.ALR4.AralSea.B
NAMPREP=$ERADIR/namelist/PRE_REAL1.nam
#NAM001=$ERADIR/namelist/name.fc36.surfex.ALR4.BXL
#name.fc36.ALR.12.4
NAM001=$ERADIR/namelist/name.fc36.surfex.ALR4.BXL_new
NAMSFX=$ERADIR/namelist/EXSEG1.nam

WORKDIR=/scratch-b/heheuili/CASIA/4km_AralBasin/LUCON
LFIDir=/scratch-b/heheuili/temp
#ALADIN_EXEC=/home/hamdi/aladin/rootpack/36t1_op2bf1.01.INTEL111073.x/bin/MASTER
#ALADIN_EXEC=/home/hamdi/aladin/pack/test36/bin/MASTERODB
#ALADIN_EXEC=/home/hamdi/aladin/pack/cy36/bin/MASTERMASTER
ALADIN_EXEC=/home/hamdi/aladin/pack/cy36new/bin/MASTER.LAI
#ENV=$ERADIR/scr/ENV_ALADIN_36
ENV=/home/daand/aladin/runs/ref38t1/ENV_ALADIN
#ENV=/home/hamdi/aladin/ENV_cy36_rafiq

DECDATE=$HOME/bin/decdate


#CLIM_50km=/mnt/HDS_ALD_TEAM/ALD_TEAM/hamdi/CENTRAL-ASIA/clim/12km/clim_m
CLIM_50km=/mnt/HDS_CLIMATE_LBC/CLIMATE_LBC/CLIM_CORDEX/ca_cordex_clim50_
#CLIM_04km=/mnt/HDS_ALD_TEAM/ALD_TEAM/hamdi/CENTRAL-ASIA/clim/4km/clim_m
CLIM_04km=/scratch-b/heheuili/PGD_Aral_Caspian/clim_model_m
#PGDBELG=/mnt/HDS_ALD_TEAM/ALD_TEAM/hamdi/CENTRAL-ASIA/clim/4km/PGD_xin4.lfi
#PGDBELG=/mnt/HDS_ALD_TEAM/ALD_TEAM/hamdi/CENTRAL-ASIA/clim/4km/PGD_XINJ_2L_ISBA_TEB_4km.lfi
#PGDBELG=/scratch-a/alaros5/XJPGD/PGD_XJ_2L_no_teb_4km.lfi
PGDBELG=/scratch-a/heheuili/PGD_Aral_Caspian/PGD_1970s_4km.lfi

LFIREPLACESST=$ERADIR/namelist/LFIreplaceSST.R
SSTERAINT=/scratch-a/heheuili/TEST

function e927
{
set -x

cDATE=$1
cRR=$2
cHH=$3
cCPLNR=$4
cBASE=$5
cEXP=$6

#++++++++++++++++++++++++ typeset -Z4 cHH ++++++++++++++
if [[ $cHH -le 9 ]]
then
cHH=000${cHH}
else
if [[ $cHH -le 99 ]]
then
cHH=00${cHH} 
else
cHH=0${cHH}
fi
fi
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



cYYYY=`echo $cDATE | cut -c1-4`
   cMM=`echo $cDATE | cut -c5-6`
   cDD=`echo $cDATE | cut -c7-8`

# --- Summer -------
  YEARS='1986'
  MONTHS='03'
  INITDAYS='01'
  LCOLD=0
if [ $cDD = $INITDAYS -a $cMM = $MONTHS ]  
then
LCOLD=1
else
LCOLD=0
fi

<<com1
for YEAR in $YEARS
  do   
  for MONTH in $MONTHS 
     do  
     for DAY in $INITDAYS
         do
         if [ $cDD = $DAY -a $cMM = $MONTH -a $cYYYY = $YEAR ]  
            then
            LCOLD=1
         fi      
         done 
     done   
done   
com1

PREVDATE=`/home/hamdi/bin/decdate $cDATE -1`
   pYYYY=`echo $PREVDATE | cut -c1-4`
   pMM=`echo $PREVDATE | cut -c5-6`
   pDD=`echo $PREVDATE | cut -c7-8`
   

   ANA_DATE=$cDATE
   let cTIME=10#${cRR}+10#$cHH
   while [ $cTIME -ge 0024 ]
   do
     ANA_DATE=`$DECDATE ${ANA_DATE} +1`
     let cTIME=10#$cTIME-10#24
   done
   ANA_MONTH=`echo ${ANA_DATE} | cut -c5-6`

#if [[ $LCOLD = 0 ]] 
#      then
       if [[ $cHH = 0012 ]]     #------------------------- Creation of TEST.lfi at the 00 range ------------------------
       then

#      scp $REMOTE:$SAVEDIR/$pYYYY/$pYYYY$pMM$pDD.tgz $pYYYY$pMM$pDD.tgz
#	   SAVEDIR=/scratch-a/heheuili/CASIA/4km_AralBasin/test/newlucc
#       cp $SAVEDIR/$pYYYY/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0024.lfi TEST.lfi

#      tar xzf $pYYYY$pMM$pDD.tgz
#      mv AROMOUT_.0024.lfi TEST.lfi

#      cp $SSTERAINT/$pYYYY/$pYYYY/$pMM/$pDD/r00/SST.lfi .
#      /home/dalex/software/bin/R CMD BATCH $LFIREPLACESST

#      rm -f AROMOUT_.*.lfi PFBE04zzzz+* $pYYYY$pMM$pDD.tgz GPFANDY* 
     
#   cp ${CLIM_40km}${ANA_MONTH} Const.Clim
#   cp ${CLIM_04km}_${ANA_MONTH} const.clim.${cEXP}

#   cp const.clim.${cEXP} const.clim.${cEXP}
#   cp const.clim.${cEXP} Const.Clim 

#   fi

#   fi


      if [[ ! -d prepSurf ]]
         then
         mkdir prepSurf
      fi
   rm -f prepSurf/*
   cd prepSurf

   cYYYY=`echo $cDATE | cut -c1-4`
   cMM=`echo $cDATE | cut -c5-6`
   cDD=`echo $cDATE | cut -c7-8`

   cp ${COUPLING}/$cYYYY/$cMM/$cDD/r$cRR/$cBASE+$cHH ICMSHE927INIT

   ANA_DATE=$cDATE
   let cTIME=10#${cRR}+10#$cHH
   while [ $cTIME -ge 0024 ]
   do
     ANA_DATE=`$DECDATE ${ANA_DATE} +1`
     let cTIME=10#$cTIME-10#24
   done
   ANA_MONTH=`echo ${ANA_DATE} | cut -c5-6`
    
   scp $REMOTE:${CLIM_50km}${ANA_MONTH} Const.Clim
#   cp $REMOTE:${CLIM_04km}${ANA_MONTH} const.clim.${cEXP}
#   cp $REMOTE:$PGDBELG PGDFILE.lfi
#   scp $PGDBELG PGDFILE.lfi
   cp ${CLIM_04km}${ANA_MONTH} const.clim.${cEXP}
   cp $PGDBELG PGDFILE.lfi

   if [[ $LCOLD = 1 ]] 
   then       
   echo 'echo MONITOR: $* >&2' >monitor.needs
   chmod +x monitor.needs

   cat $NAM927_SFX  | grep -v '^!' | sed  -e s/!.*// \
                                   -e s/{domain}/${cEXP}/ \
                                   -e s/{nbproc}/${NPROC}/ > fort.4

   cp ${NAMPREP} .

   ln -s ${ALADIN_EXEC} ALADIN

  
#   mpirun -np 1 ALADIN -eE927 -vmeteo -c001 -maladin -t1800. -ft0 -aeul
   mpiexec_mpt -np 1 ./ALADIN -eE927 -vmeteo -c001 -maladin -t1800. -ft0 -aeul > log.out 2>log.err
 

#  if [[ $cHH = 0024 ]]     #------------------------- Creation of TEST.lfi at the 00 range ------------------------
#   then

       mv INIT_SURF.lfi ../TEST.lfi
   else
       cp $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0024.lfi TEST.lfi
 #      cp $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0024.lfi TESTold.lfi
       cp $SSTERAINT/$cYYYY/$cMM/$cDD/r00/SST.lfi SST.lfi
       module purge
       module load R
       R CMD BATCH $LFIREPLACESST
       . $ENV

       cp TEST.lfi ../TEST.lfi
   fi
       cp const.clim.${cEXP} ../const.clim.${cEXP}
       cp const.clim.${cEXP} ../Const.Clim    
#   fi
#  fi

   cd ..
   fi

if [[ ! -d prep ]] 
then 
mkdir prep
fi

rm prep/*
cd prep

cYYYY=`echo $cDATE | cut -c1-4`
cMM=`echo $cDATE | cut -c5-6`
cDD=`echo $cDATE | cut -c7-8`


cp ${COUPLING}/$cYYYY/$cMM/$cDD/r$cRR/$cBASE+$cHH ICMSHE927INIT




### decide which clim file you need
ANA_DATE=$cDATE
let cTIME=10#${cRR}+10#$cHH
while [ $cTIME -ge 0024 ]
do
  ANA_DATE=`$DECDATE ${ANA_DATE} +1`
  let cTIME=10#$cTIME-10#24
done
ANA_MONTH=`echo ${ANA_DATE} | cut -c5-6`



scp $REMOTE:${CLIM_50km}${ANA_MONTH} Const.Clim
cp ${CLIM_04km}${ANA_MONTH} const.clim.${cEXP}


### and now we actually run ALADIN:
  echo 'echo MONITOR: $* >&2' >monitor.needs
  chmod +x monitor.needs
  
  cat $NAM927  | grep -v '^!' | sed  -e s/!.*// \
                                   -e s/{domain}/${cEXP}/ \
                                   -e s/{nbproc}/${NPROC}/ > fort.4
  ln -s ${ALADIN_EXEC} ALADIN

#  mpirun -np ${NPROC} ALADIN -eE927 -vmeteo -c001 -maladin -t1800. -ft0 -aeul
  mpiexec_mpt -np ${NPROC} ./ALADIN -eE927 -vmeteo -c001 -maladin -t1800. -ft0 -aeul > log.out 2>log.err

  mv PFE927${cEXP}+0000 ../ELSCF${cEXP}ALBC${cCPLNR}
  cd ..
}

#-------------------------------------------------------- coupling files --------------------------

function get_coupling
{
set -x

COUPDATE=$1
COUPRUN=$2
COUPEXP=$3

let NCOUP=10#${RUNLENGTH_04km}/3+10#1

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


while [ $CPLNR != $NCOUP ]
do

  e927 ${COUPDATE} ${RUNSTART_40km} $CTIME ${CPLNR} ICMSHCA12 ${COUPEXP}

  let CPLNR=10#$CPLNR+1
  let CTIME=10#$CTIME+3

#++++++++++++++++++++++++ typeset -Z2 CTIME ++++++++++++++
  if [[ $CTIME -le 9 ]]
  then
  CTIME=0${CTIME}
  fi

#++++++++++++++++++++++++ typeset -Z3 CPLNR ++++++++++++++
  if [[ $CPLNR -le 9 ]]
  then
  CPLNR=00${CPLNR}
  else
  CPLNR=0${CPLNR}
  fi  
done

rm -f BC*

}


#++++++++++++++++++++++++++++++++++++++++++++++++++ Forecast +++++++++++++++++++++++++++++

DATE={startdate}

. $ENV

### change the output dirctory ###
#if [[ ! -d $WORKDIR/$DATE ]]
#then
#mkdir -p $WORKDIR/$DATE
#fi

#rm -f $WORKDIR/$DATE/*
#cd $WORKDIR/$DATE


#pwd 
#ls
### change the output directory ###

YYYY=`echo $DATE | cut -c1-4`
MM=`echo $DATE | cut -c5-6`
DD=`echo $DATE | cut -c7-8`

if [[ ! -d $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART_40km ]]
then
mkdir -p $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART_40km
fi

rm -f $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART_40km/*
cd $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART_40km

pwd 
ls


### first we get the coupling files from the archive
 
 get_coupling $DATE ${RUNSTART_04km} $EXP



## and now we actually run ALADIN:
  echo 'echo MONITOR: $* >&2' >monitor.needs
  chmod +x monitor.needs

  ln -sf ELSCF${EXP}ALBC000 ICMSH${EXP}INIT

  cp $NAMSFX .
  cat $NAM001  | grep -v '^!' | sed  -e "s/!.*//" \
                                   -e "s/{cnmexp}/$EXP/" \
                                  -e "s/{neini}/0/" \
                                   -e "s/{lsprt}/.T./" \
                                   -e "s/{cfpath}/ICMSH/" \
                                   -e "s/{yyyymmdd}/${YYYY}${MM}${DD}/" \
                                   -e "s/{sssss}/$(( ${RUNSTART_04km}*3600 ))"/ \
                                  -e "s/{nproc}/${NPROC}/" > fort.4  

  ln -s ${ALADIN_EXEC} ALADIN
  ls -al

##  mpirun -np ${NPROC} ALADIN -e$EXP -vmeteo -c001 -maladin -t$TSTEP -fh${RUNLENGTH_04km}
  mpiexec_mpt -np ${NPROC} ./ALADIN -e$EXP -vmeteo -c001 -maladin -t$TSTEP -fh${RUNLENGTH_04km} > log.out 2>log.err


##### offline run over Shehezi

#ksh $ERADIR/SURFEX_OFFLINE_SHIHEZI/scr/kick_ERAINT.TEB.SFX.TEB_new_Shihezi $DATE $DATE $DAYINCREMENT 



#####offline run over urumuqi

#ksh $ERADIR/SURFEX_OFFLINE_URUMQI/scr/kick_ERAINT.TEB.SFX.TEB_new_Urumqi $DATE $DATE $DAYINCREMENT 


##### save parameters from the 4km runs

#Rscript $ERADIR/R_SCRIPT/FAtoR_cp.R $YYYY $MM $DD

#R CMD BATCH LFItoR.R $DATE 

### Save output to the archive
#ARCHIVE=$SAVEDIR/$YYYY
#tar -czf 4km_forcing_$DATE.tgz PFXIN*
#ssh $REMOTE mkdir -p -m 775 $ARCHIVE
#cp AROMOUT_.0012.lfi $LFIDir/$YYYY$MM$DD.lfi
#scp *.RData $REMOTE:$ARCHIVE/

#scp *.RData *.tgz $REMOTE:$ARCHIVE/
#rm -rf $COUPLING/$pYYYY/$pMM/$pDD/r00/*
#rm -r $COUPLING/$YYYY/$MM/$DD/$RUNSTART_04km/*
#rm $WORKDIR/$YYYY/$MM/$DD/r00/Const.Clim 
rm $WORKDIR/$YYYY/$MM/$DD/r00/Const.Clim 
rm $WORKDIR/$YYYY/$MM/$DD/r00/const.clim.XIN4 
rm $WORKDIR/$YYYY/$MM/$DD/r00/drhook.prof.*
rm $WORKDIR/$YYYY/$MM/$DD/r00/ECHALAD
rm $WORKDIR/$YYYY/$MM/$DD/r00/ELSCFXIN4ALBC*
rm $WORKDIR/$YYYY/$MM/$DD/r00/ICMSHXIN4*
<<AA
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0012.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0013.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0014.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0015.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0016.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0017.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0018.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0019.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0020.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0021.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0022.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0023.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0025.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0026.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0027.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0028.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0029.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0030.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0031.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0032.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0033.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0035.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0036.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/AROMOUT_.0034.*


rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/PFXIN4zzzz+*

AA
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/TEST.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/fort.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/log.*
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/NODE.001_01

rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/ALADIN
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/EXSEG1.nam
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/ifs.stat
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/monitor.needs
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/OUTPUT_LISTING
rm $WORKDIR/$pYYYY/$pMM/$pDD/r00/ncf927


rm -rf $WORKDIR/$YYYY/$MM/$DD/r00/prep
rm -rf $WORKDIR/$YYYY/$MM/$DD/r00/prepSurf



#tar -czf AROMOUT.tar.gz AROMOUT_*
#tar -czf PPFXIN.tar.gz PFXIN4zzzz+00*

#rm $WORKDIR/$YYYY/$MM/$DD/r00/PFXIN4zzzz+00*
#rm $WORKDIR/$YYYY/$MM/$DD/r00/AROMOUT_*

#delete the files except .tgz and .RDdata files
#shopt -s extglob
#rm -rf $WORKDIR/$YYYY/$MM/$DD/r$RUNSTART_40km/*


  NEXTDATE=`/home/duchenef/bin/decdate $DATE +$DAYINCREMENT`
  
  if [ $NEXTDATE -le $STOPDATE ] 
   then
   ksh $ERADIR/CY36-script/scr/FS/kick_200105_FS_LAIcon $NEXTDATE $STOPDATE $DAYINCREMENT 
  fi 


 
 
 

 






