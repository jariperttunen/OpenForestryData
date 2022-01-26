#!/bin/bash -l

#SBATCH -J SpaFHy_Peat
#SBATCH --account=project_2000611
#SBATCH -o error/my_output_%j
#SBATCH -e error/my_output_err_%j
#SBATCH -t 001:40:00
#SBATCH -n 1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH -p serial 
#SBATCH --partition=small
#SBATCH --mail-type=END
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kyle.eyvindson@luke.fi


module load geoconda/3.7

rm /scratch/project_2000611/Temporary/kiint/*
wait

wget -r -nd -l inf -np -A zip -P /scratch/project_2000611/Temporary/kiint/ http://www.nic.funet.fi/index/geodata/mml/kiinteisto/2020/
wait

rm /scratch/project_2000611/Temporary/Full_Metsaan/*
wait

wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Etelä-Karjala.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Etelä-Pohjanmaa.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Etelä-Savo.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Kainuu.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Kanta-Häme.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Keski-Pohjanmaa.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Keski-Suomi.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Kymenlaakso.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Lappi_E.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Lappi_P.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Pirkanmaa.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Pohjanmaa.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Pohjois-Karjala.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Pohjois-Pohjanmaa.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Pohjois-Savo.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Päijät-Häme.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Satakunta.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Uusimaa.zip &
wget -nd -l inf -np -P /scratch/project_2000611/Temporary/Full_Metsaan/ https://aineistot.metsaan.fi/avoinmetsatieto/Metsavarakuviot/Maakunta/MV_Varsinais-Suomi.zip &


wait

cd /scratch/project_2000611/Temporary/Full_Metsaan/
for zipfile in *.zip
do
unzip /scratch/project_2000611/Temporary/Full_Metsaan/$zipfile &
done

wait

