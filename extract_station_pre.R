rm(list=ls())

library(Rfa)

years = seq(1980,1989,1)

#months=seq(1,12,1)

months = seq(6,8,1)

days = c(30,31,31)

datadir = "/scratch-b/heheuili/CASIA/4km_AralBasin/"



compty = 0



file1 <- "/home/heheuili/FILE/Aral_Station_1.txt"

dat <- read.table(file1,header = FALSE,sep = "\t")

ID = dat[,1]

lat = dat[,4]

lon = dat[,5]

num1 = length(ID)



prefix = "PFXIN4zzzz+00"



ec=array(0,dim=c(num1,4))

nc=array(0,dim=c(num1,4))

ng=array(0,dim=c(num1,4))

eg=array(0,dim=c(num1,4))


days1 = sum(days)*length(years)

out1 = array(NA,dim = c(num1,days1))



i=1

for(yy in years){

  for(mm in 1:3){

    mn = months[mm]

    if (mm == 1){

      for(k in 1:days[mm]){

        if(k ==1){

          out1[1:num1,i]=NA

          i = i +1

          cat(paste(yy,"_",mn,"_",k,sep = ""),sep="\n")

        }else if(k == 2){

          times = c(12,32)

          aa = 0

          for(j in times){

            aa = aa +1

            dayskip1 = k-1

            spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dayskip1,2),"/r00/",sep="")

            eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")

            nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")

            ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")

            nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

            

            ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

            nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

            ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

            eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

            

            dec=pmax((ec[,2]-ec[,1]),0)

            dnc=pmax((nc[,2]-nc[,1]),0)

            deg=pmax((eg[,2]-eg[,1]),0)

            dng=pmax((ng[,2]-ng[,1]),0)

            

          }#j

          

          out1[1:num1,i] = dec+dnc+deg+dng

          i = i+1

          rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,j)

          cat(paste(yy,"_",mn,"_",k,sep = ""),sep="\n")

        }else{

          aa = 0 

          times=c(32,35,12,32)

          

          for (j in times){

            aa = aa +1

            if(aa <3){

              dayskip1 = k-2

              spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dayskip1,2),"/r00/",sep="")

            }else{

              dayskip1 = k-1

              spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dayskip1,2),"/r00/",sep="")

            }# pathway aa 

            

            eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")

            nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")

            ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")

            nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

            

            ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

            nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

            ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

            eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

            

            dec=pmax((ec[,2]-ec[,1]),0)

            dnc=pmax((nc[,2]-nc[,1]),0)

            deg=pmax((eg[,2]-eg[,1]),0)

            dng=pmax((ng[,2]-ng[,1]),0)

            

            dec1=pmax((ec[,4]-ec[,3]),0)

            dnc1=pmax((nc[,4]-nc[,3]),0)

            deg1=pmax((eg[,4]-eg[,3]),0)

            dng1=pmax((ng[,4]-ng[,3]),0)

            

          }#j

          out1[1:num1,i] = dec+dnc+deg+dng+dec1+dnc1+deg1+dng1

          i = i+1

          rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,dec1,dnc1,deg1,dng1,j)

          cat(paste(yy,"_",i2a(mn,2),"_",i2a(dayskip1,2),sep=""),sep = "\n")

        }#mm=1

      }

      cat(paste("++++++++++",yy,"_",mn,"_",i,"   finished","++++++++++",sep=""),sep="\n")

    }else if(mm==2){

      for(k in 1:days[mm]){

        if(k ==1){

          times=c(32,35,12,32)

          aa = 0

          for(j in times){

            aa = aa+1

            if (aa <3){

              spath = paste(datadir,yy,"/",i2a(6,2),"/",i2a(29,2),"/r00/",sep="")

            }else{

              spath = paste(datadir,yy,"/",i2a(6,2),"/",i2a(30,2),"/r00/",sep="")

            }#aa pathway

            eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")

            nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")

            ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")

            nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

            

            ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

            nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

            ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

            eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

            

            dec=pmax((ec[,2]-ec[,1]),0)

            dnc=pmax((nc[,2]-nc[,1]),0)

            deg=pmax((eg[,2]-eg[,1]),0)

            dng=pmax((ng[,2]-ng[,1]),0)

            

            

            dec1=pmax((ec[,4]-ec[,3]),0)

            dnc1=pmax((nc[,4]-nc[,3]),0)

            deg1=pmax((eg[,4]-eg[,3]),0)

            dng1=pmax((ng[,4]-ng[,3]),0)

            

            

          }#j June mm=2

          

          out1[1:num1,i] = dec+dnc+deg+dng+dec1+dnc1+deg1+dng1

          i = i+1

          rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,dec1,dnc1,deg1,dng1,j)

          cat(paste(yy,"_",mn,"_",k,sep = ""),sep="\n")

        }else if(k == 2){

          times=c(32,35,12,32)

          aa = 0

          for(j in times){

            aa = aa +1

            dayskip1 = k-1

            if (aa < 3){

              spath = paste(datadir,yy,"/",i2a(6,2),"/",i2a(30,2),"/r00/",sep="")

            }else{

              spath = paste(datadir,yy,"/",i2a(7,2),"/",i2a(1,2),"/r00/",sep="")

            }# aa pathway

            eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")

            nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")

            ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")

            nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

            

            ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

            nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

            ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

            eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

            

            dec=pmax((ec[,2]-ec[,1]),0)

            dnc=pmax((nc[,2]-nc[,1]),0)

            deg=pmax((eg[,2]-eg[,1]),0)
            dng=pmax((eg[,2]-eg[,1]),0)

            

            dec1=pmax((ec[,4]-ec[,3]),0)

            dnc1=pmax((nc[,4]-nc[,3]),0)

            deg1=pmax((eg[,4]-eg[,3]),0)

            dng1=pmax((ng[,4]-ng[,3]),0)

            

          }#j

          out1[1:num1,i] = dec+dnc+deg+dng+dec1+dnc1+deg1+dng1

          i = i+1

          rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,dec1,dnc1,deg1,dng1,j)

          cat(paste(yy,"_",mn,"_",k,sep = ""),sep="\n")

        }else{

          aa = 0 

          times=c(32,35,12,32)

          for (j in times){

            aa = aa +1

            if(aa <3){

              dayskip1 = k-2

              spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dayskip1,2),"/r00/",sep="")

            }else{

              dayskip1 = k-1

              spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dayskip1,2),"/r00/",sep="")

            }

            

            eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")

            nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")

            ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")

            nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

            

            ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

            nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

            ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

            eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

            

            dec=pmax((ec[,2]-ec[,1]),0)

            dnc=pmax((nc[,2]-nc[,1]),0)

            deg=pmax((eg[,2]-eg[,1]),0)

            dng=pmax((ng[,2]-ng[,1]),0)

            

            

            dec1=pmax((ec[,4]-ec[,3]),0)

            dnc1=pmax((nc[,4]-nc[,3]),0)

            deg1=pmax((eg[,4]-eg[,3]),0)

            dng1=pmax((ng[,4]-ng[,3]),0)

            

          }#j

          out1[1:num1,i] = dec+dnc+deg+dng+dec1+dnc1+deg1+dng1

          i = i+1

          rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,dec1,dnc1,deg1,dng1,j)

          cat(paste(yy,"_",mn,"_",k,sep = ""),sep = "\n")

        }#mm=1

      }

      cat(paste("***********",yy,"_",mn,"_",i,"   finished","***********",sep=""),sep="\n")

      }else{

        for(k in 1:days[mm]){

          if(k == 1){

            aa = 0

            times=c(32,35,12,32)

            for(j in times){

              aa = aa +1

              if (aa <3){

                spath = paste(datadir,yy,"/",i2a(7,2),"/",i2a(30,2),"/r00/",sep="")

              }else{

                spath = paste(datadir,yy,"/",i2a(7,2),"/",i2a(31,2),"/r00/",sep="")

              }# aa pathway

              eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")

              nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")

              ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")

              nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

              

              ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

              nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

              ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

              eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

              

              dec=pmax((ec[,2]-ec[,1]),0)

              dnc=pmax((nc[,2]-nc[,1]),0)

              deg=pmax((eg[,2]-eg[,1]),0)

              dng=pmax((ng[,2]-ng[,1]),0)

              

              dec1=pmax((ec[,4]-ec[,3]),0)

              dnc1=pmax((nc[,4]-nc[,3]),0)

              deg1=pmax((eg[,4]-eg[,3]),0)

              dng1=pmax((ng[,4]-ng[,3]),0)

              

            }#j

            out1[1:num1,i] = dec+dnc+deg+dng+dec1+dnc1+deg1+dng1

            i = i+1

            rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,dec1,dnc1,deg1,dng1,j)

            cat(paste(yy,"_",mn,"_",k,sep = ""),sep="\n")

          }else if(k == 2){

            aa = 0

            times=c(32,35,12,32)

            for(j in times){

              aa = aa +1

              if (aa < 3){

                spath = paste(datadir,yy,"/",i2a(7,2),"/",i2a(31,2),"/r00/",sep="")

              }else{

                spath = paste(datadir,yy,"/",i2a(8,2),"/",i2a(1,2),"/r00/",sep="")

              }# aa pathway

              eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")
              nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")
              ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")
              nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

              

              ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

              nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

              ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

              eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

              

              dec=pmax((ec[,2]-ec[,1]),0)
              dnc=pmax((nc[,2]-nc[,1]),0)
              deg=pmax((eg[,2]-eg[,1]),0)
              dng=pmax((ng[,2]-ng[,1]),0)

              

              dec1=pmax((ec[,4]-ec[,3]),0)
              dnc1=pmax((nc[,4]-nc[,3]),0)
              deg1=pmax((eg[,4]-eg[,3]),0)
              dng1=pmax((ng[,4]-ng[,3]),0)

              

            }#j

            out1[1:num1,i] = dec+dnc+deg+dng+dec1+dnc1+deg1+dng1

            i = i+1

            rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,dec1,dnc1,deg1,dng1,j)

            cat(paste(yy,"_",mn,"_",k,sep = ""),sep="\n")

            

          }else{

            aa = 0 

            times=c(32,35,12,32)

            for (j in times){

              aa = aa +1

              if(aa <3){

                dayskip1 = k-2

                spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dayskip1,2),"/r00/",sep="")

              }else{

                dayskip1 = k-1

                spath=paste(datadir,yy,"/",i2a(mn,2),"/",i2a(dayskip1,2),"/r00/",sep="")

              }# pathway aa 

              

              eca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.CON")

              nca = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.CON")

              ega = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.EAU.GEC")

              nga = FAdec(paste(spath,prefix,j,sep=""),"SURFPREC.NEI.GEC")

              

              ec[1:num1,aa]= sapply(1:num1,function(x)lalopoint(eca,lon[x],lat[x])$data, simplify="array")

              nc[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nca,lon[x],lat[x])$data, simplify="array")

              ng[1:num1,aa]= sapply(1:num1,function(x)lalopoint(ega,lon[x],lat[x])$data, simplify="array")

              eg[1:num1,aa]= sapply(1:num1,function(x)lalopoint(nga,lon[x],lat[x])$data, simplify="array")

              

              dec=pmax((ec[,2]-ec[,1]),0)

              dnc=pmax((nc[,2]-nc[,1]),0)

              deg=pmax((eg[,2]-eg[,1]),0)

              dng=pmax((ng[,2]-ng[,1]),0)

              

              dec1=pmax((ec[,4]-ec[,3]),0)

              dnc1=pmax((nc[,4]-nc[,3]),0)

              deg1=pmax((eg[,4]-eg[,3]),0)

              dng1=pmax((ng[,4]-ng[,3]),0)

              

            }#j

            out1[1:num1,i] = dec+dnc+deg+dng+dec1+dnc1+deg1+dng1

            i = i+1

            rm(times,eca,nca,ega,nga,dec,dnc,deg,dng,dec1,dnc1,deg1,dng1,j)

            cat(paste(yy,"_",mn,"_",k,sep = ""),sep="\n")

          }# August 3 -31

        }#August

        cat(paste("$$$$$$$$$$$$$",yy,"_",mn,"_",i,"   finished","$$$$$$$$$$$$$",sep=""),sep="\n")

      }#mm=1

  }#mm

  cat(paste("~~~~~~~~~",yy,"_",mm,sep = ""),sep = "\n")

}#yy



savedir = "/home/heheuili/ca_res/PRCP/station/"
dir.create(savedir)
nn = data.frame(IDname = ID,Prevalue = out1[,])

write.table(nn,paste(savedir,"full_prcp_station_day_8089.txt",sep=""),quote = FALSE, sep=",",na = "NA",row.names=FALSE,col.names=FALSE,qmethod="double")




#####################################################################################################################


