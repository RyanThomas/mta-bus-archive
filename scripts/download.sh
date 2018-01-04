#! /bin/bash

# To get the database up and running:
make make install PG_DATABASE=mta_bus_archive PSQLFLAGS="-U user" 
make init PG_DATABASE=mta_bus_archive

# This command assumes there is already a database with the tables.
# TODO: remake 
psql -U user -d mta_bus_archive -c "DELETE FROM ONLY starts"
psql -U user -d mta_bus_archive -c "DELETE FROM ONLY ends"
psql -U user -d mta_bus_archive -c "DELETE FROM ONLY trips"
psql -U user -d mta_bus_archive -c "DELETE FROM ONLY endpoints"
psql -U user -d mta_bus_archive -c "DELETE FROM ONLY final"

# For some reason, this is not populating the starts or trips tables.

d=2014-10-09
# 2014-2015
while [ "$d" != 2015-08-09 ]
   do  make download DATE="$d" PG_DATABASE=mta_bus_archive ARCHIVE=mytransit 
    
    echo "----------------------------------------------
    Download complete through ${d}.
    Cleaning up tables...
    ----------------------------------------------"
    # SQL commands to insert data info final format. Four temporary tables are used, starts, ends, trips, and endpoints.
    psql -U user -d mta_bus_archive -a -f scripts/clean.sql
    psql -U user -d mta_bus_archive -c "DELETE FROM ONLY starts"
    psql -U user -d mta_bus_archive -c "DELETE FROM ONLY ends"
    psql -U user -d mta_bus_archive -c "DELETE FROM ONLY trips"
    psql -U user -d mta_bus_archive -c "DELETE FROM ONLY endpoints"
    psql -U user -d mta_bus_archive -c "DELETE FROM ONLY rt_vehicle_positions"
    echo "----------------------------------------------
    Done cleaning up... progressing to next day.
    ----------------------------------------------"
    d=$(date -I -d "$d + 1 day")

    done
