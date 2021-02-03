#####################################################################
## Created by HHL to calculate the LAI profile over the Central Asia#
## 12 June 2019                                                     #
#####################################################################
import arcpy
from arcpy import env

from arcpy.sa import *
import glob,os, os.path, sys
arcpy.env.overwriteOutput = 1
arcpy.CheckOutExtension("Spatial")
yearn=2010
#######   hdf2tiff ########################

inPath=os.path.join('I:/MODIS_CA/LAI/',str(yearn))
outPath=os.path.join('I:/MODIS_CA/LAI/TIFF/',str(yearn))

if not os.path.exists(outPath):
        os.mkdir(outPath)

oway = 'I:/MODIS_CA/LAI/TIFF/'+str(yearn)+".txt"
f = open(oway, 'a')
env.workspace = inPath
arcpy.env.scratchWorkspace = inPath
hdfList = arcpy.ListRasters('MOD15A2H.*','hdf')
name1 = ["name"]
num1 = 0
for hdf in hdfList:
    eviName1=hdf[9:17]
    data1=arcpy.ExtractSubDataset_management(hdf,outPath +"/"+ hdf[9:17] + "_" +str(num1)+".tif", "1")
    
    aa = len(name1)
#    if aa > 0:
    if(eviName1 != name1[aa-1]):
    	name1.append(eviName1)
    	f.write(str(eviName1)+'\n')
    	print str(eviName1)
    else :
    	print "++"+str(eviName1) + "++"
#	else:
    num1 = num1+1
print "finish "
del inPath
del outPath
del env.workspace
del hdfList
del eviName1

######   projection of WGS1984 ########################

inPath = os.path.join('I:/MODIS_CA/LAI/TIFF/',str(yearn))
outPath =os.path.join('I:/MODIS_CA/LAI/TIFF/PRJ/',str(yearn))
if not os.path.exists(outPath):
        os.mkdir(outPath)

arcpy.CheckOutExtension("spatial") 

prj1 = r"D:\2019Brussels\SHP\GCS_WGS_1984.prj"
env.workspace = inPath
arcpy.env.scratchWorkspace = inPath
tifList = arcpy.ListRasters('*','tif')
for raster in tifList:
    filename = os.path.basename(raster)
    name1 = filename.split('.')[0]

    outraster = outPath+"/"+name1+'.tif'
    arcpy.ProjectRaster_management(raster, outraster, prj1,\
                                   "NEAREST", "#", "#", "#", "#")
    print "project is finished"
    arcpy.Delete_management(raster)
    print "delete the raster"
del inPath
del outPath
del env.workspace

######   append the imageses ########################

prj1 = r"D:\2019Brussels\SHP\GCS_WGS_1984.prj"

inPath =os.path.join('I:/MODIS_CA/LAI/TIFF/PRJ/',str(yearn))
outputlocation = os.path.join('I:/MODIS_CA/LAI/TIFF/',str(yearn))
file1 = "I:/MODIS_CA/LAI/TIFF/"+str(yearn)+'.txt'
f = open(file1,'r')
line1 = f.readlines()
for dd in line1:
    rr = []
    name0 = str(dd)
    name1 = name0[0:8]
    print name1
    files = glob.glob(inPath+ "/"+ name1+'*.tif')
    for rst in files:
        rr.append(rst)

    aa = len(rr)
    print str(aa)
    if aa != 0:

        inputrst = rr[0:aa]
        rst_name_with_extension = name1+'.tif'
        pixel_type = "8_BIT_UNSIGNED"

        arcpy.MosaicToNewRaster_management(inputrst, outputlocation, \
                                       rst_name_with_extension,prj1,\
                                       "8_BIT_UNSIGNED", "#", "1", "LAST","FIRST")
    else:
        print name0 + " no value"
    print "finished"
del inPath

del env.workspace
#########  setoff value and get maximum of each month #################

inPath = os.path.join('I:/MODIS_CA/LAI/TIFF/',str(yearn))
tmp = str(yearn)+"_36"
outPath = os.path.join('I:/MODIS_CA/LAI/TIFF/',tmp)
if not os.path.exists(outPath):
        os.mkdir(outPath)

months = [1,2,3,4,5,6,7,8,9,10,11,12]
rulueli = [15,31,45,60,75,91,106,121,136,152,167,182,197,213,228,244,259,274,289,304,319,334,366]

env.workspace = inPath
arcpy.env.scratchWorkspace = inPath
tifList = arcpy.ListRasters('*','tif')
jan = []
feb = []
mar = []
apr = []
may = []
jun = []
jul = []
aug = []
sep = []
oug = []
nuv = []
dec = []

janx = []
febx = []
marx = []
aprx = []
mayx = []
junx = []
julx = []
augx = []
sepx = []
ougx = []
nuvx = []
decx = []

for raster in tifList:
    filename = os.path.basename(raster)
    name0 = filename.split('.')[0]
    name1 = name0[5:8]
    print str(name1)
    
    if int(name1)<rulueli[0]:
        jan.append(raster)
    elif (int(name1)>rulueli[0] and int(name1)<=rulueli[1]):
        janx.append(raster)
    elif (int(name1)>rulueli[1] and int(name1)<=rulueli[2]):
        feb.append(raster)
    elif (int(name1)>rulueli[2] and int(name1)<=rulueli[3]):
        febx.append(raster)
    elif (int(name1)>rulueli[3] and int(name1)<=rulueli[4]):
        mar.append(raster)
    elif (int(name1)>rulueli[4] and int(name1)<=rulueli[5]):
        marx.append(raster)
    elif (int(name1)>rulueli[5] and int(name1)<=rulueli[6]):
        apr.append(raster)
    elif (int(name1)>rulueli[6] and int(name1)<=rulueli[7]):
        aprx.append(raster)
    elif (int(name1)>rulueli[7] and int(name1)<=rulueli[8]):
        may.append(raster)
    elif (int(name1)>rulueli[8] and int(name1)<=rulueli[9]):
        mayx.append(raster)
    elif (int(name1)>rulueli[9] and int(name1)<=rulueli[10]):
        jun.append(raster)
    elif (int(name1)>rulueli[10] and int(name1)<=rulueli[11]):
        junx.append(raster)
    elif (int(name1)>rulueli[11] and int(name1)<=rulueli[12]):
        jul.append(raster)
    elif (int(name1)>rulueli[12] and int(name1)<=rulueli[13]):
        julx.append(raster)
    elif (int(name1)>rulueli[13] and int(name1)<=rulueli[14]):
        aug.append(raster)
    elif (int(name1)>rulueli[14] and int(name1)<=rulueli[15]):
        augx.append(raster)
    elif (int(name1)>rulueli[15] and int(name1)<=rulueli[16]):
        sep.append(raster)
    elif (int(name1)>rulueli[16] and int(name1)<=rulueli[17]):
        sepx.append(raster)
    elif (int(name1)>rulueli[17] and int(name1)<=rulueli[18]):
        oug.append(raster)
    elif (int(name1)>rulueli[18] and int(name1)<=rulueli[19]):
        ougx.append(raster)
    elif (int(name1)>rulueli[19] and int(name1)<=rulueli[20]):
        nuv.append(raster)
    elif (int(name1)>rulueli[20] and int(name1)<=rulueli[21]):
        nuvx.append(raster)
    elif (int(name1)>rulueli[21] and int(name1)<=rulueli[22]):
        dec.append(raster)
    elif (int(name1)>rulueli[22] and int(name1)<=rulueli[23]):
        decx.append(raster)
    else:
        print "-------"+str(name1)+"----------"

aa = len(jan)
print str(aa) + "   January"
if aa !=0:
    jan0 = jan[0:aa]
    jan1 = CellStatistics(jan[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_01"+'.tif' 
    whereClause = "VALUE > 20"
    jan3 = Times(jan1,0.1)
    jan2 = SetNull(jan3,jan3, whereClause)
    jan2.save(outname)
else:
    print " jan missing"
del aa
del jan2


aa = len(janx)
print str(aa) + "   January"
if aa !=0:
    jan0 = janx[0:aa]
    jan1 = CellStatistics(janx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_01x"+'.tif' 
    whereClause = "VALUE > 20"
    jan3 = Times(jan1,0.1)
    jan2 = SetNull(jan3,jan3, whereClause)
    jan2.save(outname)
else:
    print " janx missing"
del aa

aa = len(feb)
print str(aa) + "   Feburary"
if aa !=0:
    feb0 = feb[0:aa]
    feb1 = CellStatistics(feb[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_02"+'.tif' 
    whereClause = "VALUE > 20"
    feb3 = Times(feb1,0.1)
    feb2 = SetNull(feb3,feb3, whereClause)
    feb2.save(outname)
else:
    print " feb missing"
del aa

aa = len(febx)
print str(aa) + "   Feburary"
if aa !=0:
    feb0 = febx[0:aa]
    feb1 = CellStatistics(febx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_02x"+'.tif' 
    whereClause = "VALUE > 20"
    feb3 = Times(feb1,0.1)
    feb2 = SetNull(feb3,feb3, whereClause)
    feb2.save(outname)
else:
    print " feb missing"
del aa


aa = len(mar)
print str(aa) + "   March"
if aa !=0:
    mar1 = CellStatistics(mar[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_03"+'.tif' 
    whereClause = "VALUE > 20"
    mar3 = Times(mar1,0.1)
    mar2 = SetNull(mar3,mar3, whereClause)
    mar2.save(outname)
del aa

aa = len(marx)
print str(aa) + "   March"
if aa !=0:
    mar1 = CellStatistics(marx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_03x"+'.tif' 
    whereClause = "VALUE > 20"
    mar3 = Times(mar1,0.1)
    mar2 = SetNull(mar3,mar3, whereClause)
    mar2.save(outname)
del aa


aa = len(apr)
print str(aa) + "   April"
if aa !=0:
    apr1 = CellStatistics(apr[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_04"+'.tif' 
    whereClause = "VALUE > 20"
    apr3 = Times(apr1,0.1)
    apr2 = SetNull(apr3,apr3, whereClause)
    apr2.save(outname)
del aa

aa = len(aprx)
print str(aa) + "   April"
if aa !=0:
    apr1 = CellStatistics(aprx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_04x"+'.tif' 
    whereClause = "VALUE > 20"
    apr3 = Times(apr1,0.1)
    apr2 = SetNull(apr3,apr3, whereClause)
    apr2.save(outname)
del aa


aa = len(may)
print str(aa) + "   May"
if aa !=0:
    may1 = CellStatistics(may[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_05"+'.tif' 
    whereClause = "VALUE > 20"
    may3 = Times(may1,0.1)
    may2 = SetNull(may3,may3, whereClause)
    may2.save(outname)
del aa

aa = len(mayx)
print str(aa) + "   May"
if aa !=0:
    may1 = CellStatistics(mayx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_05x"+'.tif' 
    whereClause = "VALUE > 20"
    may3 = Times(may1,0.1)
    may2 = SetNull(may3,may3, whereClause)
    may2.save(outname)
del aa

aa = len(jun)
print str(aa) + "   June"
if aa !=0:
    jun1 = CellStatistics(jun[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_06"+'.tif' 
    whereClause = "VALUE > 20"
    jun3 = Times(jun1,0.1)
    jun2 = SetNull(jun3,jun3, whereClause)
    jun2.save(outname)
del aa

aa = len(junx)
print str(aa) + "   June"
if aa !=0:
    jun1 = CellStatistics(junx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_06x"+'.tif' 
    whereClause = "VALUE > 20"
    jun3 = Times(jun1,0.1)
    jun2 = SetNull(jun3,jun3, whereClause)
    jun2.save(outname)
del aa

aa = len(jul)
print str(aa) + "   July"
if aa !=0:
    jul1 = CellStatistics(jul[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_07"+'.tif' 
    whereClause = "VALUE > 20"
    jul3 = Times(jul1,0.1)
    jul2 = SetNull(jul3,jul3, whereClause)
    jul2.save(outname)
del aa

aa = len(julx)
print str(aa) + "   July"
if aa !=0:
    jul1 = CellStatistics(julx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_07x"+'.tif' 
    whereClause = "VALUE > 20"
    jul3 = Times(jul1,0.1)
    jul2 = SetNull(jul3,jul3, whereClause)
    jul2.save(outname)
del aa



aa = len(aug)
print str(aa) + "   August"
if aa !=0:
    aug1 = CellStatistics(aug[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_08"+'.tif' 
    whereClause = "VALUE > 20"
    aug3 = Times(aug1,0.1)
    aug2 = SetNull(aug3,aug3, whereClause)
    aug2.save(outname)
del aa

aa = len(augx)
print str(aa) + "   August"
if aa !=0:
    aug1 = CellStatistics(augx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_08x"+'.tif' 
    whereClause = "VALUE > 20"
    aug3 = Times(aug1,0.1)
    aug2 = SetNull(aug3,aug3, whereClause)
    aug2.save(outname)
del aa


aa = len(sep)
print str(aa) + "   September"
if aa !=0:
    sep1 = CellStatistics(sep[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_09"+'.tif' 
    whereClause = "VALUE > 20"
    sep3 = Times(sep1,0.1)
    sep2 = SetNull(sep3,sep3, whereClause)
    sep2.save(outname)
del aa

aa = len(sepx)
print str(aa) + "   September"
if aa !=0:
    sep1 = CellStatistics(sepx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_09x"+'.tif' 
    whereClause = "VALUE > 20"
    sep3 = Times(sep1,0.1)
    sep2 = SetNull(sep3,sep3, whereClause)
    sep2.save(outname)
del aa


aa = len(oug)
print str(aa) + "   October"
if aa !=0:
    oug1 = CellStatistics(oug[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_10"+'.tif' 
    whereClause = "VALUE > 20"
    oug3 = Times(oug1,0.1)
    oug2 = SetNull(oug3,oug3, whereClause)
    oug2.save(outname)
del aa

aa = len(ougx)
print str(aa) + "   October"
if aa !=0:
    oug1 = CellStatistics(ougx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_10x"+'.tif' 
    whereClause = "VALUE > 20"
    oug3 = Times(oug1,0.1)
    oug2 = SetNull(oug3,oug3, whereClause)
    oug2.save(outname)
del aa

aa = len(nuv)
print str(aa) + "   November"
if aa !=0:
    nuv1 = CellStatistics(nuv[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_11"+'.tif' 
    whereClause = "VALUE > 20"
    nuv3 = Times(nuv1,0.1)
    nuv2 = SetNull(nuv3,nuv3, whereClause)
    nuv2.save(outname)
del aa

aa = len(nuvx)
print str(aa) + "   November"
if aa !=0:
    nuv1 = CellStatistics(nuvx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_11x"+'.tif' 
    whereClause = "VALUE > 20"
    nuv3 = Times(nuv1,0.1)
    nuv2 = SetNull(nuv3,nuv3, whereClause)
    nuv2.save(outname)
del aa

aa = len(dec)
print str(aa) + "   December"
if aa !=0:
    dec1 = CellStatistics(dec[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_12"+'.tif' 
    whereClause = "VALUE > 20"
    dec3 = Times(dec1,0.1)
    dec2 = SetNull(dec3,dec3, whereClause)
    dec2.save(outname)
del aa

aa = len(decx)
print str(aa) + "   December"
if aa !=0:
    dec1 = CellStatistics(decx[0:aa], "MAXIMUM", "NODATA")
    outname = outPath + "/"+str(yearn)+"_12x"+'.tif' 
    whereClause = "VALUE > 20"
    dec3 = Times(dec1,0.1)
    dec2 = SetNull(dec3,dec3, whereClause)
    dec2.save(outname)
del aa

del inPath
del outPath
del env.workspace
del jan
del feb
del mar
del apr
del may
del jun
del jul
del aug
del sep
del oug
del nuv
del dec
del jan1
del feb1
del mar1
del apr1
del may1
del jun1
del jul1
del aug1
del sep1
del oug1
del nuv1
del dec1

del jan2
del feb2
del mar2
del apr2
del may2
del jun2
del jul2
del aug2
del sep2
del oug2
del nuv2
del dec2

del jan3
del feb3
del mar3
del apr3
del may3
del jun3
del jul3
del aug3
del sep3
del oug3
del nuv3
del dec3

del janx
del febx
del marx
del aprx
del mayx
del junx
del julx
del augx
del sepx
del ougx
del nuvx
del decx
#######  resample to 1km ####################

inPath = os.path.join('I:/MODIS_CA/LAI/TIFF/',tmp)
tmp = str(yearn) + "_dom"
outPath = os.path.join("I:/MODIS_CA/LAI/TIFF/",tmp)
if not os.path.exists(outPath):
        os.mkdir(outPath)

res = "D:/2019Brussels/RST/LAI/ECOLIMAP_1987_CA.tif"
env.workspace = inPath
arcpy.env.scratchWorkspace = inPath
tifList = arcpy.ListRasters('*','tif')
for rst in tifList:
    filename = os.path.basename(rst)
    name0 = filename.split('.')[0]
# Execute ExtractByMask
    outExtractByMask = ExtractByMask(rst, res)
    outname = outPath + "/" + name0+'.tif'

# Save the output 
    outExtractByMask.save(outname)
    print "finished extract  " + str(name0)

#     inRectangle = Extent(52, 31.5, 75.5,51.5)

# # Execute ExtractByRectangle
#     rectExtract = ExtractByRectangle(rst, inRectangle, "INSIDE")
#     print "rectangal extract"

    
#     arcpy.Resample_management(rectExtract, outname, "0.0083321705 0.0083321705", "NEAREST")
#     print "resample 1km"



