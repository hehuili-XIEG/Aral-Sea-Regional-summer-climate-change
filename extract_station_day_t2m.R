#th land cover of 1970-------------------------------------------

rm(list=ls())
library(Rfa)
stry = 1980
endy = 1989
years = seq(stry,endy,1)
#months=seq(1,12,1)
months = c(8)
days = c(29)

datadir = "/scratch-b/heheuili/CASIA/4km_AralBasin/default/"
savedir = "/home/heheuili/ca_res/T2M/"
compty = 0

file1 <- "/home/heheuili/FILE/Aral_Station_1.txt"

dat <- read.table(file1,header = FALSE,sep = "\t")
ID = dat[,1]
lat = dat[,4]
lon = dat[,5]
num1 = length(ID)
#output="/home/heheuili/re_cas/"
prefix="AROMOUT_.00"
times=c(12:35)

ll = sum(days)*length(years)
t2mmax = array(NA,dim=c(num1,ll))
t2mmin = array(NA,dim=c(num1,ll))
bb = c(1:3)
qq=1

md = LFIopen("/scratch-b/heheuili/CASIA/4km_AralBasin/default/1986/06/02/r00/AROMOUT_.0023.lfi")
dom = attr(md,"domain")

for(yy in years){
  #print(yy)
  for (mm in bb){
    mn = months[mm]
    #print(mn)
    for (dd in 1:days[mm]){
      tmp = array(NA,dim = c(500,500,24))
      for(time in 1:24){
        LOG1 = file.exists(paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dd,2),"/r00/",sep="",prefix,times[time],".lfi"))
        if(LOG1 == TRUE){}
        spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dd,2),"/r00/",sep="",prefix,times[time],".lfi")
        vt2m = LFIdec(spath,"T2M")
        tmp[,,time] = vt2m

      }#time
      tmpmax = array(NA,dim = c(500,500))
      tmpmin = array(NA,dim = c(500,500))
      
      for(i in 1:500){
        for(j in 1:500){
          tmpmax[i,j] = max(tmp[i,j,])
          tmpmin[i,j] = min(tmp[i,j,])
        }#j
      }#i
      
      t2mmax[1:num1,qq] = sapply(1:num1,function(x)lalopoint(as.geofield(tmpmax,dom),lon[x],lat[x])$data, simplify="array")
      t2mmin[1:num1,qq] = sapply(1:num1,function(x)lalopoint(as.geofield(tmpmin,dom),lon[x],lat[x])$data, simplify="array")
      
      qq = qq+1
      cat(paste("Time: ",yy, mn, dd,sep = "_"),sep='\n')
    }#dd
  }#mm
}#yy

savedir = "/home/heheuili/ca_res/DR/"
dir.create(savedir)

nn = data.frame(IDname = ID,Prevalue = t2mmax[,])
write.table(nn,paste(savedir,"DR_t2mmax_",stry,endy,".txt",sep=""),quote = FALSE, sep=",",na = "NA",row.names=FALSE,col.names=FALSE,qmethod="double")

mm = data.frame(IDname = ID,Prevalue = t2mmin[,])
write.table(mm,paste(savedir,"DR_t2mmin_",stry,endy,".txt",sep=""),quote = FALSE, sep=",",na = "NA",row.names=FALSE,col.names=FALSE,qmethod="double")


