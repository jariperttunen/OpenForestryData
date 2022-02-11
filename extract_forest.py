import geopandas as gpd
import matplotlib
import contextily as ctx
import zipfile
import glob, os
import shutil
import pandas as pd
import multiprocessing as mp
import geopandas as gpd
import wget
import os
import subprocess
import time
import requests
from bs4 import BeautifulSoup
import multiprocessing as mp

#DEFINE PATHS
path_user = "/users/eyvindso/Church/DATA/" #NEEDS EDITING
path_scratch = "/scratch/project_2000611/Temporary/"
#DEFINE SHAPEFILE FOR PROPERTIES
Properties = gpd.read_file(path_user + "/ALL_Properties_FARM.shp")

#List of metsään geopackage databases
os.chdir(path_scratch +"Full_Metsaan")
list_files = []
for file in glob.glob("*.gpkg"):
    list_files = list_files+[file]
print(list_files)

#function to extract forest information
#Two options-- option one, simply based on intersection (i.e. if any property information is overtop of forest information)

def output_forest(i):
    FOREST = gpd.read_file(path_scratch +"Full_Metsaan/"+i)
    res_union = gpd.overlay(Properties, FOREST, how='intersection')
    return res_union

#Multiprocessing to speed things up
print(mp.cpu_count())
pool = mp.Pool(mp.cpu_count())
DATA =  pool.map(output_forest,list_files)

print("DONE")
    
t4 = 0

#Checks overlay of each stand, and if the calculation of areas is different (by 20% then ignore)
for i in DATA:
    print(i["standid"]) #I'd rather select the standid's from metsää-fi database than the intersection (due to gaps and such)
    i['geom_area'] = i.geometry.area
    i['percentage_area'] = (i['area']-i['geom_area']/10000)/i['area']
    i = i[i['percentage_area']<0.2]
    if t4 == 0:
        ids = i['standid']
        t3 = i
        t4 = 1
    else:
        t3 = t3.append(i)
        ids = ids.append(i['standid'])
t3 = t3.drop_duplicates() 
t3.to_file(path_user +"ALL_FOREST_FARM_check.shp")


#Option 2: select based off of id.
def output_forest_select_by_id(i):
    FOREST = gpd.read_file(path_scratch +"Full_Metsaan/"+i)
    res_union = FOREST[FOREST['standid'].isin(ids)]
    return res_union

print(mp.cpu_count())
pool = mp.Pool(mp.cpu_count())

DATA =  pool.map(output_forest_select_by_id,list_files)
    
t4 = 0

for i in DATA:
    print(i["standid"]) #I'd rather select the standid's from metsää-fi database than the intersection (due to gaps and such)
    if t4 == 0:
        ids = i['standid']
        t3 = i
        t4 = 1
    else:
        t3 = t3.append(i)
        ids = ids.append(i['standid'])
t3 = t3.drop_duplicates() 
t3.to_file(path_user +"ALL_FOREST_FARM_by_id.shp")

