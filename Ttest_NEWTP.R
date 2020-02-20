###########################################################
#
#
#                 Temperature Annual 
#
#
#############################################################

rm(list=ls())
library(Rfa)
inway = '/scratch-a/heheuili/RData/T2M/Yearly/'

con = load(paste(inway,"1980_2015_yearly.RData",sep=""))

con_mean = t2mmean
con_max = t2mmax
con_min = t2mmin

rm(t2mmean,t2mmax,t2mmin,con)

chg = load(paste(inway,"NEWLUCHG_yearly.RData",sep=""))

chg_mean = con_mean
chg_max = con_mean
chg_min = con_mean

pvalue_mean=array(NA,dim=c(500,500))
sig_mean = array(NA,dim=c(500,500))

pvalue_min=array(NA,dim=c(500,500))
sig_min = array(NA,dim=c(500,500))

pvalue_max=array(NA,dim=c(500,500))
sig_max = array(NA,dim=c(500,500))

for(i in 1:500)
{
  for(j in 1:500)
  {
    #pvalue[i,j]=t.test(newpre[i,j,],oldpre[i,j,],paired=T,conf.level=0.99)$p.value
    pvalue_mean[i,j]=t.test(con_mean[i,j,],chg_mean[i,j,],paired=T)$p.value
    pvalue_min[i,j]=t.test(con_min[i,j,],chg_min[i,j,],paired=T)$p.value
    pvalue_max[i,j]=t.test(con_max[i,j,],chg_max[i,j,],paired=T)$p.value

    if(pvalue_mean[i,j] <= 0.01){
      sig_mean[i,j] = -(as.numeric(mean(con_mean[i,j,])) - as.numeric(mean(chg_mean[i,j,])))
    }#if
    if(pvalue_max[i,j] <= 0.01){
      sig_max[i,j] = -(as.numeric(mean(con_max[i,j,])) - as.numeric(mean(chg_max[i,j,])))
    }#if
    if(pvalue_min[i,j] <= 0.01){
      sig_min[i,j] = -(as.numeric(mean(con_min[i,j,])) - as.numeric(mean(chg_min[i,j,])))
    }#if

  }#j
}#i

md = LFIdec("/scratch-b/heheuili/CASIA/4km_AralBasin/CHG/1997/06/01/r00/AROMOUT_.0024.lfi","T2M")
dom = attr(md,"domain")

outpth = "/home/heheuili/Fig/T2M/"
dir.create(outpth)
Aral = read.table("/home/heheuili/FILE/Aral.txt",header = T, sep=",")
Aral2005 = read.table("/home/heheuili/FILE/2005Aral.txt",header = T, sep=",")
Aral2015_p1 = read.table("/home/heheuili/FILE/2015Aral_p1.txt",header = T, sep=",")
Aral2015_p2 = read.table("/home/heheuili/FILE/2015Aral_p2.txt",header = T, sep=",")
Aral2015_p3 = read.table("/home/heheuili/FILE/2015Aral_p3.txt",header = T, sep=",")
Aral2015_p4 = read.table("/home/heheuili/FILE/2015Aral_p4.txt",header = T, sep=",")

pdf(paste(outpth,"Tmean_sigdif_multiyearly_sig001.pdf",sep=""))
iview(subgrid(as.geofield(sig_mean,dom),80,480,50,450),legend=T)
points(project(Aral$Lon1,Aral$Lat1,dom$projection),type="l",lwd=1)
points(project(Aral2005$Lon1,Aral2005$Lat1,dom$projection),type="l",lwd=1,col="blue")
points(project(Aral2015_p1$Lon1,Aral2015_p1$Lat1,dom$projection),type="l",lwd=1,col="red")
points(project(Aral2015_p2$Lon1,Aral2015_p2$Lat1,dom$projection),type="l",lwd=1,col="red")
points(project(Aral2015_p3$Lon1,Aral2015_p3$Lat1,dom$projection),type="l",lwd=1,col="red")
points(project(Aral2015_p4$Lon1,Aral2015_p4$Lat1,dom$projection),type="l",lwd=1,col="red")
dev.off()
