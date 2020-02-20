##########################33  MEAN ######################################
rm(list=ls())

workdir = "/scratch-a/heheuili/RData/T2M/Yearly/"
setwd(workdir)

yr = c(1980:2015)
tp = load(paste(workdir,"1980_2015_LUCHG_yearly.RData",sep = ""))
preout1 = array(NA,dim = c(500,500,4))

for(i in 1:500){
  for(j in 1:500){
    tmpmean = chg_mean1[i,j,]
    result1 = summary(lm(tmpmean~yr))
    preout1[i,j,1] = as.numeric(result1$coefficients[2]) #trend coefficients
    preout1[i,j,2] = as.numeric(result1$coefficients[8]) #p_value
    preout1[i,j,3] = as.numeric(result1$coefficients[1])  #interception
    r = cor(yr,tmpmean)
    preout1[i,j,4] = r*r
  }#j
}#i
library(Rfa)
md = LFIdec("/scratch-a/heheuili/CASIA/4km_AralBasin/LU1970s/1980/06/01/r00/AROMOUT_.0024.lfi","T2M")
dom = attr(md,"domain")
rm(tmpmean)
trend1 = array(NA,dim = c(500,500))
for(i in 1:500){
  for(j in 1:500){
    tmpmean = preout1[i,j,2]
    if(tmpmean<=0.1){
      trend1[i,j] = preout1[i,j,1]
    }
  }#j
}#i

outpth = "/home/heheuili/Fig/T2M/CON_CHG/"
dir.create(outpth)

Aral = read.table("/home/heheuili/FILE/Aral.txt",header = T, sep=",")
Aral2005 = read.table("/home/heheuili/FILE/2005Aral.txt",header = T, sep=",")
Aral2015_p1 = read.table("/home/heheuili/FILE/2015Aral_p1.txt",header = T, sep=",")
Aral2015_p2 = read.table("/home/heheuili/FILE/2015Aral_p2.txt",header = T, sep=",")
Aral2015_p3 = read.table("/home/heheuili/FILE/2015Aral_p3.txt",header = T, sep=",")
Aral2015_p4 = read.table("/home/heheuili/FILE/2015Aral_p4.txt",header = T, sep=",")


pdf(paste(outpth,"Tmean_LUCHG_yearly_trend_sig01.pdf",sep=""))
iview(as.geofield(trend1,dom),legend=T,levels = c(-1.2,-0.8,-0.4,0,0.05,0.1,0.15,0.2,0.5,1.4),title="Mean Temperature with Changing LUCC from 1980 to 2015")
points(project(Aral$Lon1,Aral$Lat1,dom$projection),type="l",lwd=1)
points(project(Aral2005$Lon1,Aral2005$Lat1,dom$projection),type="l",lwd=1,col="blue")
points(project(Aral2015_p1$Lon1,Aral2015_p1$Lat1,dom$projection),type="l",lwd=1,col="red")
points(project(Aral2015_p2$Lon1,Aral2015_p2$Lat1,dom$projection),type="l",lwd=1,col="red")
points(project(Aral2015_p3$Lon1,Aral2015_p3$Lat1,dom$projection),type="l",lwd=1,col="red")
points(project(Aral2015_p4$Lon1,Aral2015_p4$Lat1,dom$projection),type="l",lwd=1,col="red")

dev.off()
