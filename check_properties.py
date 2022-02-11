import geopandas as gpd
import matplotlib
import contextily as ctx
import zipfile
import glob, os
import shutil
import pandas as pd
import multiprocessing as mp

#Folders of interest:
#scratch folder to hold large data
path_scratch = "/scratch/project_2000611/Temporary/"
#Folder keeping data that doesn't change
path_user = "/users/eyvindso/Church/"
#List of properties to be included in the shapefile
Kiinte = pd.read_csv(path_user+"DATA/Kiinteistotunnukset_string.csv",sep=";", dtype=str)
Kiinte = list(Kiinte['TUNNUS'])

#DOWNLOAD Kiinteisto information done in the bash file.
os.chdir(path_scratch+"kiint")
#WGET

#Unziping all zip files -- should only be the maps of property files.
list_files = []
for file in glob.glob("*.zip"):
    list_files = list_files+[file]
print(list_files)
    
k = 0
# A function to make a temporary folder, unzip the folder, 
def run_zips(i):
    print(i)
    os.mkdir(path_scratch +"kiint/"+i[0:-4])
    with zipfile.ZipFile(path_scratch +"kiint/"+i, 'r') as zip_ref:
        zip_ref.extractall(path_scratch +"kiint/"+i[0:-4]+"/")
    shape = gpd.read_file(path_scratch +"kiint/"+i[0:-4]+"/"+i[0:-4]+"_palstaalue.shp")
    #Extract only those properties that are desired.
    if len(shape[shape['TUNNUS'].isin(Kiinte)])> 0:
        t3 = shape[shape['TUNNUS'].isin(Kiinte)]
    else:
        t3 = 0
    if len(shape[shape['TUNNUS'].isin(Kiinte)]) > 0:
        with zipfile.ZipFile("/scratch/project_2000611/Temporary/kiint/"+i, 'r') as zip_ref:
            zip_ref.extractall("/scratch/project_2000611/Temporary/kiint/keep/")
    shutil.rmtree(path_scratch +"kiint/"+i[0:-4])
    return t3

print(mp.cpu_count())
pool = mp.Pool(mp.cpu_count())

#Multiprocessing to aid in speed: runs the function above, on the max number of cores

DATA =  pool.map(run_zips,list_files)

#This section creates a csv file to the temp folder. (Not sure what it actually does)
j = 0
for i in DATA:
    if isinstance(i, int): #I think that it is checking if the first value is an integer, if not then ... it has geometry
        j = j+1
    else:
        i.to_csv(path_scratch +"kiint/temp/"+str(list_files[j])+".csv")
        j=j+1

t4 = 0
k = 0
#This section groups all of the data together into a single shape file.
for i in DATA:
    if isinstance(i, int):
        k=k+1
    else:
        if t4 == 0:
            t3 = i
            t4 = 1
        else:
            t3 = t3.append(i)


t3.to_file(path_user +"DATA/ALL_Properties_FARM.shp")        
    
