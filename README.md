# Aral-Sea-Regional-summer-climate-change
TITLE:Impacts of historical land use/cover change (1980-2015) on summer climate in the Aral Sea region
Step 1: replace the land cover in default ECOCLIMAP  (ECOCLIMAP.m)
Step 2: calculate the LAI profile in Central Asia (LAI.pr.py)
Step 3: Make Domain, create the pgd for domain in order to have the orography (make_pgd_923_model.aral)
Step 4: create the clim file for the same domain (job_923_model.aral)
Step 5: create the physical pgd with cy36 (job_pgd_aral.sh)
Step 6: run the 50 km runs over the Central Asia for the period from 1980-1989 (script_outerdomain.sh)
Step 7: run the 4 km runs over the Aral Sea region with default parameters for the period from  1980-1989 (script_outerdomain.sh)
Step 8: run the 4 km runs over the Aral Sea region with updated parameters for the period from  1980-1989 
Step 9: extract the modeling result and compare with observation
Step 10: repeat step 6 - step 8 but for period 1980-2012
Step 11: 


The *.sh files are used for running ALARO-SURFEX model
The extract_station*.R files are used for extract the simulation in meteorological stations
The Ttest_TP.R is used for student t test and only plot the grids pass the significant test.
The LS_CHG.R is used for calculating the trend of temperature.
The zip file is EC tower and land use land cover data.
